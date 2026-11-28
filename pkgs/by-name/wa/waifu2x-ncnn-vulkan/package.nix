{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  # build-time
  cmake,
  vulkan-headers,

  # run-time
  glslang,
  libjpeg_turbo,
  libpng,
  libwebp,
  ncnn,
  vulkan-loader,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waifu2x-ncnn-vulkan";
  version = "20250915";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nihui";
    repo = "waifu2x-ncnn-vulkan";
    tag = "${finalAttrs.version}";
    sha256 = "sha256-ZW4g9cdOZQMBo+L+1lt6szsge3fWKKnD1+W9SV14Byc=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    ./models_path.patch
  ];

  postPatch = ''
    substituteInPlace main.cpp \
      --replace-fail "REPLACE_MODELS" "$out/opt/models-cunet"
  '';

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_NCNN" true)
    (lib.cmakeBool "USE_SYSTEM_WEBP" true)
    (lib.cmakeBool "USE_SYSTEM_JPEG" true)
    (lib.cmakeBool "USE_SYSTEM_ZLIB" true)
    (lib.cmakeBool "USE_SYSTEM_PNG" true)
    (lib.cmakeFeature "GLSLANG_TARGET_DIR" "${glslang}/lib/cmake")
  ];

  nativeBuildInputs = [
    cmake
    vulkan-headers
  ];

  buildInputs = [
    glslang
    libjpeg_turbo
    libpng
    libwebp
    ncnn
    vulkan-loader
    zlib
  ];

  postInstall = ''
    mkdir -p $out/opt
    cp -R $src/models/* $out/opt
    mv $out/bin/waifu2x-ncnn-vulkan $out/opt
    ln -s $out/opt/waifu2x-ncnn-vulkan $out/bin/waifu2x-ncnn-vulkan
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/waifu2x-ncnn-vulkan \
      --add-needed ${vulkan-loader}/lib/libvulkan.so.1
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "NCNN implementation of the waifu2x image-upscaling tool, using the Vulkan API";
    homepage = "https://github.com/nihui/waifu2x-ncnn-vulkan";
    mainProgram = "waifu2x-ncnn-vulkan";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
