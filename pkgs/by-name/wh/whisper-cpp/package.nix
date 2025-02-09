{
  lib,
  stdenv,
  cmake,
  apple-sdk_11,
  ninja,
  fetchFromGitHub,
  SDL2,
  wget,
  which,
  autoAddDriverRunpath,
  makeWrapper,

  metalSupport ? stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64,
  coreMLSupport ? stdenv.hostPlatform.isDarwin && false, # FIXME currently broken

  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },

  rocmSupport ? config.rocmSupport,
  rocmPackages ? { },
  rocmGpuTargets ? builtins.concatStringsSep ";" rocmPackages.clr.gpuTargets,

  vulkanSupport ? false,
  shaderc,
  vulkan-headers,
  vulkan-loader,

  withSDL ? true,
}:

assert metalSupport -> stdenv.hostPlatform.isDarwin;
assert coreMLSupport -> stdenv.hostPlatform.isDarwin;

let
  # It's necessary to consistently use backendStdenv when building with CUDA support,
  # otherwise we get libstdc++ errors downstream.
  # cuda imposes an upper bound on the gcc version, e.g. the latest gcc compatible with cudaPackages_11 is gcc11
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
  inherit (lib)
    cmakeBool
    cmakeFeature
    optional
    optionals
    optionalString
    forEach
    ;

  darwinBuildInputs = [ apple-sdk_11 ];

  cudaBuildInputs = with cudaPackages; [
    cuda_cccl # <nv/target>

    # A temporary hack for reducing the closure size, remove once cudaPackages
    # have stopped using lndir: https://github.com/NixOS/nixpkgs/issues/271792
    cuda_cudart
    libcublas
  ];

  rocmBuildInputs = with rocmPackages; [
    clr
    hipblas
    rocblas
  ];

  vulkanBuildInputs = [
    shaderc
    vulkan-headers
    vulkan-loader
  ];

in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "whisper-cpp";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "whisper.cpp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-y30ZccpF3SCdRGa+P3ddF1tT1KnvlI4Fexx81wZxfTk=";
  };

  # The upstream download script tries to download the models to the
  # directory of the script, which is not writable due to being
  # inside the nix store. This patch changes the script to download
  # the models to the current directory of where it is being run from.
  patches = [ ./download-models.patch ];

  postPatch = ''
    for target in examples/{bench,command,main,quantize,server,stream,talk}/CMakeLists.txt; do
      if ! grep -q -F 'install('; then
        echo 'install(TARGETS ''${TARGET} RUNTIME)' >> $target
      fi
    done
  '';

  nativeBuildInputs =
    [
      cmake
      ninja
      which
      makeWrapper
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
      autoAddDriverRunpath
    ];

  buildInputs =
    optional withSDL SDL2
    ++ optionals effectiveStdenv.hostPlatform.isDarwin darwinBuildInputs
    ++ optionals cudaSupport cudaBuildInputs
    ++ optionals rocmSupport rocmBuildInputs
    ++ optionals vulkanSupport vulkanBuildInputs;

  cmakeFlags =
    [
      (cmakeBool "WHISPER_BUILD_EXAMPLES" true)
      (cmakeBool "GGML_CUDA" cudaSupport)
      (cmakeBool "GGML_HIPBLAS" rocmSupport)
      (cmakeBool "GGML_VULKAN" vulkanSupport)
      (cmakeBool "WHISPER_SDL2" withSDL)
      (cmakeBool "GGML_LTO" true)
      (cmakeBool "GGML_NATIVE" false)
      (cmakeBool "BUILD_SHARED_LIBS" (!effectiveStdenv.hostPlatform.isStatic))
    ]
    ++ optionals (effectiveStdenv.hostPlatform.isx86 && !effectiveStdenv.hostPlatform.isStatic) [
      (cmakeBool "GGML_BACKEND_DL" true)
      (cmakeBool "GGML_CPU_ALL_VARIANTS" true)
    ]
    ++ optionals cudaSupport [
      (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
    ]
    ++ optionals rocmSupport [
      (cmakeFeature "CMAKE_C_COMPILER" "hipcc")
      (cmakeFeature "CMAKE_CXX_COMPILER" "hipcc")

      # Build all targets supported by rocBLAS. When updating search for TARGET_LIST_ROCM
      # in https://github.com/ROCmSoftwarePlatform/rocBLAS/blob/develop/CMakeLists.txt
      # and select the line that matches the current nixpkgs version of rocBLAS.
      "-DAMDGPU_TARGETS=${rocmGpuTargets}"
    ]
    ++ optionals coreMLSupport [
      (cmakeBool "WHISPER_COREML" true)
      (cmakeBool "WHISPER_COREML_ALLOW_FALLBACK" true)
    ]
    ++ optionals metalSupport [
      (cmakeFeature "CMAKE_C_FLAGS" "-D__ARM_FEATURE_DOTPROD=1")
      (cmakeBool "GGML_METAL" true)
      (cmakeBool "GGML_METAL_EMBED_LIBRARY" true)
    ];

  postInstall = ''
    # Add "whisper-cpp" prefix before every command
    mv -v $out/bin/{main,whisper-cpp}

    for file in $out/bin/*; do
      if [[ -x "$file" && -f "$file" && "$(basename $file)" != "whisper-cpp" ]]; then
        mv -v "$file" "$out/bin/whisper-cpp-$(basename $file)"
      fi
    done

    install -v -D -m755 $src/models/download-ggml-model.sh $out/bin/whisper-cpp-download-ggml-model

    wrapProgram $out/bin/whisper-cpp-download-ggml-model \
      --prefix PATH : ${lib.makeBinPath [ wget ]}
  '';

  requiredSystemFeatures = optionals rocmSupport [ "big-parallel" ]; # rocmSupport multiplies build time by the number of GPU targets, which takes arround 30 minutes on a 16-cores system to build

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/whisper-cpp --help >/dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "Port of OpenAI's Whisper model in C/C++";
    longDescription = ''
      To download the models as described in the project's readme, you may
      use the `whisper-cpp-download-ggml-model` binary from this package.
    '';
    homepage = "https://github.com/ggerganov/whisper.cpp";
    license = lib.licenses.mit;
    mainProgram = "whisper-cpp";
    platforms = lib.platforms.all;
    broken = coreMLSupport;
    badPlatforms = optionals cudaSupport lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      dit7ya
      hughobrien
      aviallon
    ];
  };
})
