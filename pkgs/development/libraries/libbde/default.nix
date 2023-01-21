{ lib
, stdenv
, fetchurl
, fuse
, ncurses
, python3
}:

stdenv.mkDerivation rec {
  pname = "libbde";
  version = "20221031";

  src = fetchurl {
    url = "https://github.com/libyal/libbde/releases/download/${version}/${pname}-alpha-${version}.tar.gz";
    sha256 = "sha256-uMbwofboePCFWlxEOdRbZK7uZuj0MZC/qusWuu0Bm7g=";
  };

  buildInputs = [ fuse ncurses python3 ];

  configureFlags = [ "--enable-python" ];

  meta = with lib; {
    description = "Library to access the BitLocker Drive Encryption (BDE) format";
    homepage = "https://github.com/libyal/libbde/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ eliasp ];
    platforms = platforms.all;
  };
}
