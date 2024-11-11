{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ncnn,
  glslang,
  libwebp,
  vulkan-headers,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "upscayl-ncnn";
  version = "20240601-103425";

  src = fetchFromGitHub {
    owner = "upscayl";
    repo = "upscayl-ncnn";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-rGnjL+sU5x3VXHnvuYXVdxGmHdj9eBkIZK3CwL89lN0=";
  };

  patches = [
    # those cmake files used are deprecated by glslang
    # and have invalid paths when built by Nix
    # https://github.com/upscayl/upscayl-ncnn/pull/5
    ./fix_deprecated_glslang_include.patch
  ];

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    ncnn
    glslang
    libwebp
    vulkan-headers
    vulkan-loader
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_NCNN" true)
    (lib.cmakeBool "USE_SYSTEM_WEBP" true)
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 upscayl-bin $out/bin/upscayl-ncnn

    runHook postInstall
  '';

  meta = {
    description = "Upscayl backend powered by the NCNN framework and Real-ESRGAN architecture";
    homepage = "https://github.com/upscayl/upscayl-ncnn";
    license = lib.licenses.agpl3Only;
    mainProgram = "upscayl-ncnn";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.all;
  };
})
