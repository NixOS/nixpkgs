# TODO(@connorbaker): cuda_cudart.dev depends on crt/host_config.h, which is from
# (getDev cuda_nvcc). It would be nice to be able to encode that.
{
  _cuda,
  addDriverRunpath,
  arrayUtilities,
  autoFixElfFiles,
  backendStdenv,
  cuda_cccl,
  cuda_compat,
  cuda_crt ? null,
  cuda_nvcc,
  cudaAtLeast,
  lib,
  patchelf,
}:
prevAttrs: {
  propagatedBuildOutputs = prevAttrs.propagatedBuildOutputs or [ ] ++ [
    "static" # required by CMake
    "stubs" # always propagate, even when cuda_compat is used, to avoid symbol linking errors
  ];

  # When cuda_compat is available, propagate it.
  # NOTE: `cuda_compat` can be disabled by setting the package to `null`. This is useful in cases where
  # the host OS has a recent enough CUDA driver that the compatibility library isn't needed.
  propagatedBuildInputs =
    prevAttrs.propagatedBuildInputs or [ ]
    # Add the dependency on NVCC's include directory.
    # - crt/host_config.h
    # TODO(@connorbaker): Check that the dependency offset for this is correct.
    ++ [ (lib.getOutput "include" cuda_nvcc) ]
    # TODO(@connorbaker): From CUDA 13.0, crt/host_config.h is in cuda_crt
    ++ lib.optionals (cudaAtLeast "13.0") [ (lib.getOutput "include" cuda_crt) ]
    # Add the dependency on CCCL's include directory.
    # - nv/target
    # TODO(@connorbaker): Check that the dependency offset for this is correct.
    ++ [ (lib.getOutput "include" cuda_cccl) ]
    ++ lib.optionals (backendStdenv.hasJetsonCudaCapability && cuda_compat != null) [
      cuda_compat
    ];

  allowFHSReferences = false;

  postPatch =
    prevAttrs.postPatch or ""
    # Patch the `cudart` package config files so they reference lib
    + ''
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

  postInstall =
    prevAttrs.postInstall or ""
    # Namelink may not be enough, add a soname.
    # Cf. https://gitlab.kitware.com/cmake/cmake/-/issues/25536
    # NOTE: Relative symlinks is fine since this is all within the same output.
    + ''
      pushd "''${!outputStubs:?}/lib/stubs" >/dev/null
      if [[ -f libcuda.so && ! -f libcuda.so.1 ]]; then
        nixLog "creating versioned symlink for libcuda.so stub"
        ln -srv libcuda.so libcuda.so.1
      fi
      nixLog "creating symlinks for stubs in lib directory"
      ln -srvt "''${!outputStubs:?}/lib/" *.so *.so.*
      popd >/dev/null
    '';

  passthru = prevAttrs.passthru or { } // {
    platformAssertions =
      prevAttrs.passthru.platformAssertions or [ ]
      ++ lib.optionals (cudaAtLeast "13.0") (
        _cuda.lib._mkMissingPackagesAssertions { inherit cuda_crt; }
      );

    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      # NOTE: A number of packages expect cuda_cudart to be in a single directory.
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
        "static"
        "stubs"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "CUDA Runtime";
  };
}
