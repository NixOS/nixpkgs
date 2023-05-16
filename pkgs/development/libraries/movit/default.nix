<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, pkg-config
, SDL2
, fftw
, gtest
, darwin
, eigen
, libepoxy
}:

stdenv.mkDerivation rec {
  pname = "movit";
  version = "1.7.1";

  src = fetchurl {
    url = "https://movit.sesse.net/${pname}-${version}.tar.gz";
    sha256 = "sha256-szBztwXwzLasSULPURUVFUB7QLtOmi3QIowcLLH7wRo=";
=======
{ lib, stdenv, fetchurl, SDL2, eigen, libepoxy, fftw, gtest, pkg-config }:

stdenv.mkDerivation rec {
  pname = "movit";
  version = "1.6.3";

  src = fetchurl {
    url = "https://movit.sesse.net/${pname}-${version}.tar.gz";
    sha256 = "164lm5sg95ca6k546zf775g3s79mgff0az96wl6hbmlrxh4z26gb";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" ];

  GTEST_DIR = "${gtest.src}/googletest";

<<<<<<< HEAD
  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    SDL2
    fftw
    gtest
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.OpenGL
    darwin.libobjc
  ];

  propagatedBuildInputs = [
    eigen
    libepoxy
  ];

  env = lib.optionalAttrs stdenv.isDarwin {
    NIX_LDFLAGS = "-framework OpenGL";
  };
=======
  propagatedBuildInputs = [ eigen libepoxy ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL2 fftw gtest ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  enableParallelBuilding = true;

  meta = with lib; {
    description = "High-performance, high-quality video filters for the GPU";
    homepage = "https://movit.sesse.net";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
<<<<<<< HEAD
    platforms = platforms.unix;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
