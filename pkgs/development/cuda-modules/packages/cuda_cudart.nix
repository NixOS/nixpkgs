{
  addDriverRunpath,
  buildRedist,
  cccl,
  cuda_compat,
  cuda_crt,
  cuda_nvcc,
  lib,
  runCommand,
}:
let
  # These headers form part of cudart's public compile interface. Keep both
  # stdenv propagation and standalone pkg-config consumers on the same inputs.
  publicHeaderInputs = [
    (lib.getOutput cuda_crt.outputInclude cuda_crt)
    (lib.getOutput cccl.outputInclude cccl)
  ];
in
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "cuda_cudart";

  # NOTE: A number of packages expect cuda_cudart to be in a single directory. We restrict the package to a single
  # output to avoid breaking these assumptions. As an example, CMake expects the static libraries to exist alongside
  # the dynamic libraries.
  outputs = [
    "out"
  ];

  # We have stubs but we don't have an explicit stubs output.
  includeRemoveStubsFromRunpathHook = true;

  propagatedBuildOutputs = [
    # required by CMake
    finalAttrs.outputStatic
    # always propagate, even when cuda_compat is used, to avoid symbol linking errors
    finalAttrs.outputStubs
  ];

  # When cuda_compat is available, propagate it.
  # NOTE: `cuda_compat` can be disabled by setting the package to `null`. This is useful in cases where
  # the host OS has a recent enough CUDA driver that the compatibility library isn't needed.
  propagatedBuildInputs =
    publicHeaderInputs
    # NOTE: cuda_compat may be null or unavailable
    ++ lib.optionals (cuda_compat.meta.available or false) [ cuda_compat ];

  allowFHSReferences = false;

  # Publish the public headers for consumers outside stdenv as well.
  postPatch = ''
    local path=""
    while IFS= read -r -d $'\0' path; do
      nixLog "patching $path"
      sed -i \
        -e "s|^cudaroot\s*=.*\$||" \
        -e "s|^Cflags\s*:\(.*\)\$|Cflags: \1${
          lib.concatMapStrings (input: " -I${input}/include") publicHeaderInputs
        }|" \
        -e "s|^Libs\s*:\(.*\)\$|Libs: \1 -Wl,-rpath,${addDriverRunpath.driverLink}/lib|" \
        "$path"
    done < <(find -iname 'cudart-*.pc' -print0)
    unset -v path
  ''
  # Patch the `cuda` package config files so they reference stubs
  # TODO: Will this always pull in the stubs output and cause its setup hook to be executed?
  + ''
    local path=""
    while IFS= read -r -d $'\0' path; do
      nixLog "patching $path"
      sed -i \
        -e "s|^cudaroot\s*=.*\$||" \
        -e "s|^libdir\s*=.*/lib\$|libdir=''${!outputStubs:?}/lib/stubs|" \
        -e "s|^Libs\s*:\(.*\)\$|Libs: \1 -Wl,-rpath,${addDriverRunpath.driverLink}/lib|" \
        "$path"
    done < <(find -iname 'cuda-*.pc' -print0)
    unset -v path
  '';

  # Namelink may not be enough, add a soname.
  # Cf. https://gitlab.kitware.com/cmake/cmake/-/issues/25536
  # NOTE: Relative symlinks is fine since this is all within the same output.
  postInstall = ''
    pushd "''${!outputStubs:?}/lib/stubs" >/dev/null
    if [[ -f libcuda.so && ! -f libcuda.so.1 ]]; then
      nixLog "creating versioned symlink for libcuda.so stub"
      ln -srv libcuda.so libcuda.so.1
    fi
    popd >/dev/null
  '';

  # NVCC depends on its default runtime. Checking the reverse dependency in
  # cudart's own derivation would make evaluating their output paths cyclic.
  # Retain the closure check as an independent test instead.
  # "Never again", cf. https://github.com/NixOS/nixpkgs/pull/457424
  passthru.tests.no-compiler =
    runCommand "${finalAttrs.name}-no-compiler"
      {
        disallowedRequisites = [ (lib.getOutput cuda_nvcc.outputBin cuda_nvcc) ];
      }
      # Aggregate out need not reach a separate development output.
      ''
        mkdir "$out"
        ${lib.concatMapStringsSep "\n" (output: ''
          ln -s ${lib.getOutput output finalAttrs.finalPackage} "$out/${output}"
        '') finalAttrs.outputs}
      '';

  meta.description = "CUDA Runtime";
})
