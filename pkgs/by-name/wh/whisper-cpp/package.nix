{
  lib,
  stdenv,
  cmake,
  git,
  ninja,
  fetchFromGitHub,
  SDL2,
  wget,
  which,
  ffmpeg-headless,
  llama-cpp,
  makeWrapper,
  nix-update-script,

  metalSupport ? stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64,
  coreMLSupport ? stdenv.hostPlatform.isDarwin && true,

  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },

  rocmSupport ? config.rocmSupport,
  rocmPackages ? { },

  vulkanSupport ? false,

  withSDL ? true,

  withFFmpegSupport ? stdenv.hostPlatform.isLinux,
}:

assert metalSupport -> stdenv.hostPlatform.isDarwin;
assert coreMLSupport -> stdenv.hostPlatform.isDarwin;
assert withFFmpegSupport -> stdenv.hostPlatform.isLinux;

let
  # It's necessary to consistently use backendStdenv when building with CUDA support,
  # otherwise we get libstdc++ errors downstream.
  # cuda imposes an upper bound on the gcc version
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
  inherit (lib)
    cmakeBool
    optional
    optionals
    ;

  inherit (effectiveStdenv.hostPlatform)
    isStatic
    isLinux
    isAarch64
    ;

  # whisper-talk-llama needs llama.cpp, and upstream only supports the system
  # one together with its ggml (WHISPER_USE_SYSTEM_LLAMA forces
  # WHISPER_USE_SYSTEM_GGML). The compute backends therefore come from
  # llama-cpp and the acceleration options are passed on to it.
  llama-cpp' = llama-cpp.override {
    inherit
      cudaSupport
      cudaPackages
      rocmSupport
      rocmPackages
      vulkanSupport
      metalSupport
      ;
  };

in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "whisper-cpp";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "whisper.cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qqqpt+pvCQwSbyaBr1bdb7q+3LbELTcloHdiSikGPc4=";
  };

  # The upstream download script tries to download the models to the
  # directory of the script, which is not writable due to being
  # inside the nix store. This patch changes the script to download
  # the models to the current directory of where it is being run from.
  patches = [ ./download-models.patch ];

  nativeBuildInputs = [
    cmake
    git
    ninja
    which
    makeWrapper
  ];

  buildInputs = optional withSDL SDL2 ++ optional withFFmpegSupport ffmpeg-headless;

  # whisper.h includes ggml.h and whisper.pc links to libggml.
  propagatedBuildInputs = [ llama-cpp' ];

  cmakeFlags = [
    (cmakeBool "WHISPER_BUILD_EXAMPLES" true)
    (cmakeBool "WHISPER_USE_SYSTEM_LLAMA" true)
    (cmakeBool "WHISPER_SDL2" withSDL)
    (cmakeBool "BUILD_SHARED_LIBS" (!isStatic))
  ]
  ++ optionals isLinux [
    (cmakeBool "WHISPER_COMMON_FFMPEG" withFFmpegSupport)
  ]
  ++ optionals coreMLSupport [
    (cmakeBool "WHISPER_COREML" true)
    (cmakeBool "WHISPER_COREML_ALLOW_FALLBACK" true)
  ];

  postInstall = ''
    install -v -D -m755 "$src/models/download-ggml-model.sh" "$out/bin/whisper-cpp-download-ggml-model"

    wrapProgram "$out/bin/whisper-cpp-download-ggml-model" \
      --prefix PATH : ${lib.makeBinPath [ wget ]}
  ''
  + lib.optionalString withFFmpegSupport ''
    wrapProgram "$out/bin/whisper-server" \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  # libcuda.so is provided by the driver at runtime and is not available in the sandbox
  # /nix/store/...-whisper-cpp-1.8.3/bin/whisper-cli: error while loading shared libraries: libcuda.so.1: cannot open shared object file: No such file or directory
  # NOTE: it is unclear why this isn't an issue on x86_64-linux
  doInstallCheck = !(isLinux && isAarch64 && cudaSupport);

  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/whisper-cli" --help >/dev/null
    "$out/bin/parakeet-cli" --help >/dev/null
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Port of OpenAI's Whisper model in C/C++";
    longDescription = ''
      To download the models as described in the project's readme, you may
      use the `whisper-cpp-download-ggml-model` binary from this package.
    '';
    homepage = "https://github.com/ggerganov/whisper.cpp";
    license = lib.licenses.mit;
    mainProgram = "whisper-cli";
    platforms = lib.platforms.all;
    badPlatforms = optionals cudaSupport lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      hughobrien
      aviallon
    ];
  };
})
