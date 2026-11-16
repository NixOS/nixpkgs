{
  addDriverRunpath,
  backendStdenv,
  buildRedist,
  cccl,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  cuda_nvrtc,
  cudaAtLeast,
  cudaMajorVersion,
  flags,
  lib,
  libcublas,
  libcufft,
  libcurand,
  libcusolver,
  libcusparse,
  libnvjitlink,
  ninja,
}:
let
  # Example targets the gpuCheck builds and runs, by example project.
  # NOTE: MathDx 25.06.1 is the last release for CUDA 12 (see the cublasdx manifests).
  examples = lib.filterAttrs (_: targets: targets != [ ]) (
    if cudaMajorVersion == "12" then
      {
        cublasdx = [ "introduction_example" ];
        cufftdx = [ "introduction_example" ];
        curanddx = [ "philox_thread_api" ];
        # On aarch64, the cuSolverDx examples need CUDA 12.8 or newer to link its fatbin.
        cusolverdx = lib.optionals (backendStdenv.hostPlatform.isx86_64 || cudaAtLeast "12.8") [
          "posv_batched"
        ];
      }
    else
      {
        # cuBLASDx's TRSM needs its fatbin, which the examples skip for architecture-specific targets before CUDA 13.2
        # (NVBUG5504462).
        cublasdx = [
          "introduction_example"
        ]
        ++ lib.optionals (
          cudaAtLeast "13.2"
          || !lib.any (cap: lib.hasSuffix "a" cap || lib.hasSuffix "f" cap) backendStdenv.cudaCapabilities
        ) [ "trsm_block" ];
        cufftdx = [ "introduction_example" ];
        curanddx = [ "philox_thread_api" ];
        cusolverdx = [ "posv_batched_block" ];
      }
  );
in
buildRedist (finalAttrs: {
  redistName = "cublasdx";
  pname = "mathdx";

  # The archive's contents are in nvidia/mathdx/<major>.<minor>.
  setSourceRoot = "sourceRoot=$(echo */nvidia/mathdx/${lib.versions.majorMinor finalAttrs.version})";

  # The layout is otherwise kept as-is: the CMake package configuration files locate the headers, libraries, and
  # bundled CUTLASS relative to themselves.
  # NOTE: libcusolverdx.a and libnvcompdx.a hold x86_64 code on every platform (elsewhere, CMake uses the lib*.fatbin
  # variants), but the CMake targets require them to exist.
  outputs = [
    "out"
    "doc"
  ];

  outputToPatterns.doc = [
    "doc"
    "example"
  ];

  # cuFFTDx's example Makefiles expect a CUDA Toolkit in /usr/local/cuda; the examples also build with CMake, as in the
  # gpuCheck.
  # cuBLASDx's performance guide helper is not executable, so patchShebangs leaves its /usr/bin/env shebang, which the
  # FHS reference check rejects; its usage is `python3 suggest_tile.py`, so drop the shebang.
  postPatch = ''
    find example -name Makefile -print -delete
  ''
  + lib.optionalString (lib.versionAtLeast finalAttrs.version "26.10") ''
    substituteInPlace example/cublasdx/performance_guide/suggest_tile.py \
      --replace-fail '#!/usr/bin/env python3' ""
  '';

  # Don't strip the x86_64 static libraries.
  dontStrip = true;

  # Builds NVIDIA's example projects against the installed package and runs an example from each library.
  passthru.gpuCheck = backendStdenv.mkDerivation {
    __structuredAttrs = true;
    strictDeps = true;

    name = "${finalAttrs.finalPackage.name}-gpu-check";

    src = "${finalAttrs.finalPackage.doc}/example";

    nativeBuildInputs = [
      cmake
      cuda_nvcc
      ninja
    ];

    buildInputs = [
      cccl
      cuda_cudart
      cuda_nvrtc
      finalAttrs.finalPackage
      libcublas # cuSolverDx examples
      libcufft # cuFFTDx examples
      libcurand # cuRANDDx examples
      libcusolver # cuSolverDx examples
      libcusparse # cuSolverDx examples
      libnvjitlink
    ];

    dontUseCmakeConfigure = true;

    # NOTE: For device linking, nvlink only searches the nvcc.profile directories, which lack cuda_cudart's
    # libcudadevrt.
    buildPhase = ''
      runHook preBuild
    ''
    + lib.concatStrings (
      lib.mapAttrsToList (project: targets: ''
        cmake -G Ninja -S ${project} -B build-${project} \
          -DCMAKE_BUILD_TYPE=Release \
          -D${lib.toUpper project}_CUDA_ARCHITECTURES=${lib.escapeShellArg flags.cmakeCudaArchitecturesString} \
          -DCMAKE_CUDA_FLAGS=-L${lib.getLib cuda_cudart}/lib
        ninja -C build-${project} ${lib.escapeShellArgs targets}
      '') examples
    )
    + ''
      runHook postBuild
    '';

    doCheck = true;
    checkPhase = ''
      runHook preCheck

      export LD_LIBRARY_PATH="$(readlink -mnv "${addDriverRunpath.driverLink}/lib")"
      for example in ${
        lib.escapeShellArgs (
          lib.concatLists (lib.mapAttrsToList (project: map (target: "build-${project}/${target}")) examples)
        )
      }; do
        # Examples are built in per-project subdirectories which vary between releases.
        example="$(find "$(dirname "$example")" -type f -name "$(basename "$example")" -executable -print -quit)"
        nixLog "running $example"
        "$example"
      done

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall
      touch "$out"
      runHook postInstall
    '';

    requiredSystemFeatures = [ "cuda" ];

    meta = {
      inherit (finalAttrs.finalPackage.meta) badPlatforms platforms teams;
    };
  };

  meta = {
    description = "NVIDIA Math Libraries Device Extensions (cuBLASDx, cuFFTDx, cuRANDDx, cuSolverDx, and nvCOMPDx)";
    longDescription = ''
      MathDx is a collection of device function libraries for performing mathematical operations (dense linear
      algebra, FFTs, random number generation, solvers, and compression) inside CUDA kernels, allowing them to be
      fused with other operations.
    '';
    homepage = "https://developer.nvidia.com/mathdx";
    downloadPage = "https://developer.nvidia.com/cublasdx-downloads";
    changelog = "https://docs.nvidia.com/cuda/mathdx/release_notes.html";
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      fromSource # headers and bundled CUTLASS
    ];
    license = with lib.licenses; [
      nvidiaMath_sdk_sla
      bsd3 # bundled CUTLASS
    ];
  };
})
