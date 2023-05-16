<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, cmake
}:

stdenv.mkDerivation rec {
  pname = "libunarr";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/selmf/unarr/releases/download/v${version}/unarr-${version}.tar.xz";
    hash = "sha256-5wCnhjoj+GTmaeDTCrUnm1Wt9SsWAbQcPSYM//FNeOA=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace "-flto" "" \
      --replace "AppleClang" "Clang"
  '';

  nativeBuildInputs = [
    cmake
  ];
=======
{ lib, stdenv, fetchurl, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "libunarr";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/selmf/unarr/releases/download/v${version}/unarr-${version}.tar.xz";
    sha256 = "1db500k6w90qn6qb4j3zcczailmmv81q9lv4bwq516hbncg5p4sl";
  };

  nativeBuildInputs = [ cmake ];

  # https://github.com/selmf/unarr/issues/23
  postPatch = ''
    substituteInPlace pkg-config.pc.cmake \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  ''
  # ld: unknown option: --no-undefined
  + lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace '-Wl,--no-undefined -Wl,--as-needed' '-Wl,-undefined,error'
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/selmf/unarr";
    description = "A lightweight decompression library with support for rar, tar and zip archives";
    license = licenses.lgpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
