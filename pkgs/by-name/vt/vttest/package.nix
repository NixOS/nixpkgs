{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vttest";
  version = "20241204";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/vttest/vttest-${version}.tgz"
      "ftp://ftp.invisible-island.net/vttest/vttest-${version}.tgz"
    ];
    sha256 = "sha256-cBDDK2Qllo7NfuxD2J8sbGdElPc7Isjnxm2t8hwjG/8=";
  };

  meta = with lib; {
    description = "Tests the compatibility of so-called 'VT100-compatible' terminals";
    homepage = "https://invisible-island.net/vttest/";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "vttest";
  };
}

