# TODO(@connorbaker): cuda_cudart.dev depends on crt/host_config.h, which is from
# (getDev cuda_nvcc). It would be nice to be able to encode that.
{
  _cuda,
  addDriverRunpath,
  buildRedist,
  cuda_cccl,
  cuda_compat,
  cuda_crt,
  cuda_nvcc,
  cudaAtLeast,
  lib,
}:
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

  propagatedBuildOutputs =
    # required by CMake
    lib.optionals (lib.elem "static" finalAttrs.outputs) [ "static" ]
    # always propagate, even when cuda_compat is used, to avoid symbol linking errors
    ++ lib.optionals (lib.elem "stubs" finalAttrs.outputs) [ "stubs" ];

  # When cuda_compat is available, propagate it.
  # NOTE: `cuda_compat` can be disabled by setting the package to `null`. This is useful in cases where
  # the host OS has a recent enough CUDA driver that the compatibility library isn't needed.
  propagatedBuildInputs =
    # TODO(@SomeoneSerge): Consider propagating `crt/host_config.h`, but only
    # once we managed to split out `cuda_nvcc`'s headers into a separate output
    #
    # TODO(@connorbaker): Check that the dependency offset for this is correct.
    #
    # [ (lib.getInclude cuda_nvcc) ]

    # TODO(@connorbaker): From CUDA 13.0, crt/host_config.h is in cuda_crt
    lib.optionals (cudaAtLeast "13.0") [ (lib.getOutput "include" cuda_crt) ]
    # Add the dependency on CCCL's include directory.
    # - nv/target
    # TODO(@connorbaker): Check that the dependency offset for this is correct.
    ++ [ (lib.getOutput "include" cuda_cccl) ]
    # NOTE: cuda_compat may be null or unavailable
    ++ lib.optionals (cuda_compat.meta.available or false) [ cuda_compat ];

  allowFHSReferences = false;

  # Patch the `cudart` package config files so they reference lib
  postPatch = ''
    local path=""
    while IFS= read -r -d $'\0' path; do
      nixLog "patching $path"
      sed -i \
        -e "s|^cudaroot\s*=.*\$||" \
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

  # "Never again", cf. https://github.com/NixOS/nixpkgs/pull/457424
  disallowedRequisites = [ (lib.getBin cuda_nvcc) ];

  meta.description = "CUDA Runtime";
})
