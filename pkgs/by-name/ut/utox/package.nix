{
  lib,
  stdenv,
  fetchFromGitHub,
  check,
  cmake,
  pkg-config,
  libtoxcore,
  filter-audio,
  dbus,
  libvpx,
  libX11,
  openal,
  freetype,
  libv4l,
  libXrender,
  fontconfig,
  libXext,
  libXft,
  libsodium,
  libopus,
}:

stdenv.mkDerivation rec {
  pname = "utox";

  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "uTox";
    repo = "uTox";
    tag = "v${version}";
    hash = "sha256-DxnolxUTn+CL6TbZHKLHOUMTHhtTSWufzzOTRpKjOwc=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libtoxcore
    dbus
    libvpx
    libX11
    openal
    freetype
    libv4l
    libXrender
    fontconfig
    libXext
    libXft
    filter-audio
    libsodium
    libopus
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DENABLE_AUTOUPDATE=OFF"
    "-DENABLE_TESTS=${if doCheck then "ON" else "OFF"}"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)"
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeCheckInputs = [ check ];

  meta = with lib; {
    description = "Lightweight Tox client";
    mainProgram = "utox";
    homepage = "https://github.com/uTox/uTox";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
