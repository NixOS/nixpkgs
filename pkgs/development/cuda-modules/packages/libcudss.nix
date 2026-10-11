{
  backendStdenv,
  buildRedist,
  lib,
  libcublas,
  mpi,
  nccl,
}:
buildRedist {
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
  # NOTE: NVIDIA builds the MPI communication layer against OpenMPI 4.x:
  # https://docs.nvidia.com/cuda/cudss/index.html
  ++ lib.optionals nccl.meta.available [
    mpi
    nccl
  ];

  # NCCL is not available on all platforms (e.g., Jetson Orin), and we only provide MPI and NCCL together; the
  # communication layers which require them are loaded at runtime only when requested.
  autoPatchelfIgnoreMissingDeps = lib.optionals (!nccl.meta.available) [
    "libmpi.so.40"
    "libnccl.so.2"
  ];

  # https://docs.nvidia.com/cuda/cudss/index.html
  platformAssertions = [
    {
      message =
        "cuDSS supports CUDA compute capabilities 6.0 and newer"
        + " (found ${builtins.toJSON backendStdenv.cudaCapabilities})";
      assertion = lib.all (lib.flip lib.versionAtLeast "6.0") backendStdenv.cudaCapabilities;
    }
  ];

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
        "set(_cudss_search_prefix \"''${!outputDev:?}/lib;''${!outputLib:?}/lib;''${!outputInclude:?}/include\")"

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

  meta = {
    description = "Library of GPU-accelerated linear solvers with sparse matrices";
    longDescription = ''
      NVIDIA cuDSS (Preview) is a library of GPU-accelerated linear solvers with sparse matrices.
    '';
    homepage = "https://developer.nvidia.com/cudss";
    changelog = "https://docs.nvidia.com/cuda/cudss/release_notes.html";
  };
}
