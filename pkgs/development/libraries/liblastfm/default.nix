{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  which,
  cmake,
  fftwSinglePrec,
  libsamplerate,
  qtbase,
}:

stdenv.mkDerivation {
  pname = "liblastfm-unstable";
  version = "2019-08-23";

  src = fetchFromGitHub {
    owner = "lastfm";
    repo = "liblastfm";
    rev = "2ce2bfe1879227af8ffafddb82b218faff813db9";
    sha256 = "1crih9xxf3rb109aqw12bjqv47z28lvlk2dpvyym5shf82nz6yd0";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/lastfm/liblastfm/commit/9c5d072b55f2863310e40291677e6397e9cbc3c2.patch";
      name = "0001-Remove-deprecated-staging-server-and-fix-test-for-QT5-at-Ubuntu-19.10.patch";
      sha256 = "04r14prydxshjgfws3pjajjmp2msszhjjs1mjh8s66yg29vq620l";
    })
  ];

  # CMake 2.8.6 is deprecated and no longer supported by CMake > 4
  # https://github.com/NixOS/nixpkgs/issues/445447
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.8.6)" \
      "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    pkg-config
    which
    cmake
  ];
  buildInputs = [
    fftwSinglePrec
    libsamplerate
    qtbase
  ];

  env.NIX_CFLAGS_COMPILE =
    (lib.optionalString (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") "-std=c++11")
    + (lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-dynamic-exception-spec");

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/lastfm/liblastfm";
    description = "Official LastFM library";
    platforms = platforms.unix;
    maintainers = [ ];
    license = licenses.gpl3;
  };
}
