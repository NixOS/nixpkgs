{
  cmake,
  fetchFromGitHub,
  fetchzip,
  glslang,
  installShellFiles,
  lib,
  libwebp,
  ncnn,
  stdenv,
  vulkan-headers,
  vulkan-loader,
}:

# upscayl-ncnn is a fork of /pkgs/by-name/re/realesrgan-ncnn-vulkan, so the nix package is basically the same.
stdenv.mkDerivation (finalAttrs: {
  pname = "upscayl-ncnn";
  version = "20240601-103425";

  src = fetchFromGitHub {
    owner = "upscayl";
    repo = "upscayl-ncnn";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-rGnjL+sU5x3VXHnvuYXVdxGmHdj9eBkIZK3CwL89lN0=";
  };

  models = fetchzip {
    # Choose the newst release from https://github.com/xinntao/Real-ESRGAN/releases to update
    url = "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-ubuntu.zip";
    hash = "sha256-1YiPzv1eGnHrazJFRvl37+C1F2xnoEbN0UQYkxLT+JQ=";
    stripRoot = false;
  };

  patches = [
    ./cmakelists.patch
    ./models_path.patch
  ];

  sourceRoot = "${finalAttrs.src.name}/src";

  postPatch = ''
    substituteInPlace main.cpp --replace REPLACE_MODELS $out/share/models
  '';

  nativeBuildInputs = [
    cmake
    glslang
    installShellFiles
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_NCNN" true)
    (lib.cmakeBool "USE_SYSTEM_WEBP" true)
    (lib.cmakeFeature "GLSLANG_TARGET_DIR" "${glslang}/lib/cmake")
  ];

  buildInputs = [
    vulkan-loader
    libwebp
    ncnn
    vulkan-headers
    glslang
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share

    installBin upscayl-bin
    ln -s ${finalAttrs.models}/models $out/share

    runHook postInstall
  '';

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux "-rpath ${
    lib.makeLibraryPath [ vulkan-loader ]
  }";

  meta = {
    changelog = "https://github.com/upscayl/upscayl-ncnn/releases/tag/${finalAttrs.version}";
    description = "Upscayl backend powered by the NCNN framework and Real-ESRGAN architecture";
    homepage = "https://github.com/upscayl/upscayl-ncnn";
    license = lib.licenses.agpl3Only;
    mainProgram = "upscayl-bin";
    maintainers = with lib.maintainers; [
      grimmauld
      getchoo
    ];
    platforms = lib.platforms.all;
  };
})
