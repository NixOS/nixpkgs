{
  lib,
  stdenv,
  cmake,
  darwin,
  ninja,
  fetchFromGitHub,
  SDL2,
  wget,
  which,
  autoAddDriverRunpath,
  makeWrapper,
  autoPatchelfHook,

  metalSupport ? stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64,

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
    ;

  darwinBuildInputs =
    with darwin.apple_sdk_11_0.frameworks;
    [
      Accelerate
      CoreVideo
      CoreGraphics
      CoreML # only exists in SDK 11.0 or 12.3
    ]
    ++ optionals metalSupport [ MetalKit ];

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

  nativeBuildInputs =
    [
      cmake
      ninja
      which
      makeWrapper
      autoPatchelfHook
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
      (cmakeBool "CMAKE_SKIP_BUILD_RPATH" true) # the project doesn't install the main binaries in their installation target
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
    ++ optionals effectiveStdenv.hostPlatform.isDarwin [
      (cmakeBool "GGML_METAL" metalSupport)
      (cmakeBool "GGML_METAL_EMBED_LIBRARY" metalSupport)
      (cmakeBool "WHISPER_COREML" true)
      (cmakeBool "WHISPER_COREML_ALLOW_FALLBACK" true)
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
    ++ optionals metalSupport [
      (cmakeFeature "CMAKE_C_FLAGS" "-D__ARM_FEATURE_DOTPROD=1")
      (cmakeBool "LLAMA_METAL_EMBED_LIBRARY" true)
    ];

  postInstall = ''
    # Add "whisper-cpp" prefix before every command
    install -v -D -m755 ./bin/main $out/bin/whisper-cpp

    pushd bin
    for file in *; do
      if [[ -x "$file" && -f "$file" && "$file" != "main" ]]; then
        install -v -D -m755 "$file" "$out/bin/whisper-cpp-$file"
      fi
    done
    popd

    addAutoPatchelfSearchPath $out/lib

    install -v -D -m755 $src/models/download-ggml-model.sh $out/bin/whisper-cpp-download-ggml-model

    wrapProgram $out/bin/whisper-cpp-download-ggml-model \
      --prefix PATH : ${lib.makeBinPath [ wget ]}
  '';

  requiredSystemFeatures = optionals rocmSupport [ "big-parallel" ]; # rocmSupport multiplies build time by the number of GPU targets, which takes arround 30 minutes on a 16-cores system to build

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
    badPlatforms = optionals cudaSupport lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      dit7ya
      hughobrien
      aviallon
    ];
  };
})
