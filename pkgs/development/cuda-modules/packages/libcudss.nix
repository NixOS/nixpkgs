{
  buildRedist,
  callPackage,
  cuda_cudart,
  lib,
  libcublas,
  mpi,
  nccl,
}:
buildRedist (finalAttrs: {
  redistName = "cudss";
  pname = "libcudss";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ];

  buildInputs = [
    libcublas
  ]
  # MPI brings in NCCL dependency by way of UCC/UCX.
  ++ lib.optionals nccl.meta.available [
    mpi
    nccl
  ];

  # cudss.h exposes CUDA runtime types to consumers.
  propagatedBuildInputs = [ cuda_cudart ];

  # Update the CMake configurations
  postFixup = ''
    pushd "''${!outputDev:?}/lib/cmake/cudss" >/dev/null

    nixLog "patching $PWD/cudss-config.cmake to fix relative paths"
    substituteInPlace "$PWD/cudss-config.cmake" \
      --replace-fail \
        'get_filename_component(PACKAGE_PREFIX_DIR "''${CMAKE_CURRENT_LIST_DIR}/../../../../" ABSOLUTE)' \
        "" \
      --replace-fail \
        'file(REAL_PATH "../../" _cudss_search_prefix BASE_DIRECTORY "''${_cudss_cmake_config_realpath}")' \
        "set(_cudss_search_prefix \"''${!outputDev:?}/lib;''${!outputLib:?}/lib;''${!outputInclude:?}/include\")" \
      --replace-fail '## Targets' 'include(CMakeFindDependencyMacro)
    find_dependency(CUDAToolkit)

    ## Targets'

    # Keep standalone CMake consumers on the same public header interface.
    substituteInPlace "$PWD/cudss-targets.cmake" \
      --replace-fail \
        'INTERFACE_INCLUDE_DIRECTORIES "''${cudss_INCLUDE_DIR}"' \
        'INTERFACE_INCLUDE_DIRECTORIES "''${cudss_INCLUDE_DIR}"
      INTERFACE_LINK_LIBRARIES "CUDA::toolkit"'
    # The archive leaves CUDA runtime calls unresolved. Match NVCC's default
    # static runtime and retain CMake's platform-specific system dependencies.
    substituteInPlace "$PWD/cudss-static-targets.cmake" \
      --replace-fail \
        'INTERFACE_LINK_LIBRARIES "\$<LINK_ONLY:cublas>"' \
        'INTERFACE_LINK_LIBRARIES "CUDA::toolkit;\$<LINK_ONLY:cublas>;\$<LINK_ONLY:CUDA::cudart_static>"'

    nixLog "patching $PWD/cudss-static-targets.cmake to fix INTERFACE_LINK_DIRECTORIES for cublas"
    sed -Ei \
      's|INTERFACE_LINK_DIRECTORIES "/usr/local/cuda.*/lib64"|INTERFACE_LINK_DIRECTORIES "${lib.getLib libcublas}/lib"|g' \
      "$PWD/cudss-static-targets.cmake"
    if grep -Eq 'INTERFACE_LINK_DIRECTORIES "/usr/local/cuda.*/lib64"' "$PWD/cudss-static-targets.cmake"; then
      nixErrorLog "failed to patch $PWD/cudss-static-targets.cmake"
      exit 1
    fi

    nixLog "patching $PWD/cudss-static-targets-release.cmake to fix the path to the static library"
    substituteInPlace "$PWD/cudss-static-targets-release.cmake" \
      --replace-fail \
        '"''${cudss_LIBRARY_DIR}/libcudss_static.a"' \
        "\"''${!outputStatic:?}/lib/libcudss_static.a\""

    popd >/dev/null
  '';

  passthru.tests.cmake = callPackage ./tests/libcudss-cmake.nix {
    libcudss = finalAttrs.finalPackage;
  };

  meta = {
    description = "Library of GPU-accelerated linear solvers with sparse matrices";
    longDescription = ''
      NVIDIA cuDSS (Preview) is a library of GPU-accelerated linear solvers with sparse matrices.
    '';
    homepage = "https://developer.nvidia.com/cudss";
    changelog = "https://docs.nvidia.com/cuda/cudss/release_notes.html";
  };
})
