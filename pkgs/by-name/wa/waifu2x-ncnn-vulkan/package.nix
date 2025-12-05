{
  lib,
  stdenv,
  cmake,
  glslang,
  vulkan-headers,
  vulkan-loader,
  ncnn,
  libwebp,
  libjpeg,
  libpng,
  zlib,
  makeWrapper,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "waifu2x-ncnn-vulkan";
  version = "20250915";

  src = fetchFromGitHub {
    owner = "nihui";
    repo = "waifu2x-ncnn-vulkan";
    rev = "a86cfb043e6482b5f08778a114df9b5faf6e73b7";
    hash = "sha256-ZW4g9cdOZQMBo+L+1lt6szsge3fWKKnD1+W9SV14Byc=";
  };

  nativeBuildInputs = [
    cmake
    glslang
    vulkan-headers
  ];
  buildInputs = [
    libwebp
    libjpeg
    libpng
    zlib
    ncnn
    vulkan-loader
    makeWrapper
  ];

  postPatch = ''
     substituteInPlace src/main.cpp \
    --replace-fail 'PATHSTR("models' 'PATHSTR("${placeholder "out"}/share/models'
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_NCNN=ON"
    "-DUSE_SYSTEM_WEBP=ON"
    "-DUSE_SYSTEM_JPEG=ON"
    "-DUSE_SYSTEM_ZLIB=ON"
    "-DUSE_SYSTEM_PNG=ON"
  ];

  preConfigure = ''
    cd src
  '';

  postInstall = ''
    mkdir -p $out/share/waifu2x-ncnn-vulkan
    cp -r $src/models/* $out/share/
  '';

  postFixup = ''
    wrapProgram $out/bin/waifu2x-ncnn-vulkan \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = with lib; {
    description = "ncnn implementation of waifu2x converter";
    homepage = "https://github.com/nihui/waifu2x-ncnn-vulkan";
    maintainers = with lib.maintainers; [ Dry-Leaf ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
