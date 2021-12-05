{ lib, stdenv, fetchurl, fuse, ncurses, python3 }:

stdenv.mkDerivation rec {
  pname = "libbde";
  version = "20210605";

  src = fetchurl {
    url =
      "https://github.com/libyal/libbde/releases/download/${version}/${pname}-alpha-${version}.tar.gz";
    sha256 = "0dk5h7gvp2fgg21n7k600mnayg4g4pc0lm7317k43j1q0p4hkfng";
  };

  buildInputs = [ fuse ncurses python3 ];

  configureFlags = [ "--enable-python" ];

  meta = with lib; {
    description =
      "Library to access the BitLocker Drive Encryption (BDE) format";
    homepage = "https://github.com/libyal/libbde/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ eliasp ];
    platforms = platforms.all;
  };
}
