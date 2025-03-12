{
  lib,
  stdenv,
  fetchurl,
  vulkan-headers,
  vulkan-tools,
  vulkan-loader,
  glslang,
  glfw,
  libjpeg,
  pkg-config,
  rsync,
  cmake,
  clang,
  llvm,
  llvmPackages,
  pugixml,
  freetype,
  exiv2,
  ffmpeg,
  libvorbis,
  libmad,
  testers,
  vkdt,
  xxd,
  alsa-lib,
  cargo,
  rustPlatform,
}:

stdenv.mkDerivation rec {
  pname = "vkdt";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/hanatos/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-+oVPZRI01IxMSPXOjvUXJutYXftQM7GxwVLG8wqoaY4=";
  };

  strictDeps = true;

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rawler-0.6.3" = "sha256-EJ0uWc3pp7ixRxDIdTIVVaT2ph3P2IvuK+ecBSB5HYw=";
    };
  };
  cargoRoot = "src/pipe/modules/i-raw/rawloader-c";

  nativeBuildInputs = [
    cargo
    clang
    cmake
    glslang
    llvm
    llvmPackages.openmp
    pkg-config
    rsync
    rustPlatform.cargoSetupHook
    xxd
  ];

  buildInputs = [
    alsa-lib
    exiv2
    ffmpeg
    freetype
    glfw
    libjpeg
    libmad
    libvorbis
    llvmPackages.openmp
    pugixml
    vulkan-headers
    vulkan-loader
    vulkan-tools
  ];

  dontUseCmakeConfigure = true;

  makeFlags = [
    "DESTDIR=$(out)"
    "prefix="
  ];

  passthru.tests.version = testers.testVersion {
    package = vkdt;
  };

  meta = with lib; {
    description = "Vulkan-powered raw image processor";
    homepage = "https://github.com/hanatos/vkdt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.linux;
  };
}
