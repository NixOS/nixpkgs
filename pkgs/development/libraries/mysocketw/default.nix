{ lib, stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  pname = "mysocketw";
  version = "031026";
  src = fetchurl {
    url = "https://www.digitalfanatics.org/cal/socketw/files/SocketW${version}.tar.gz";
    sha256 = "0crinikhdl7xihzmc3k3k41pgxy16d5ci8m9sza1lbibns7pdwj4";
  };

  patches = [ ./gcc.patch ];

  buildInputs = [ openssl ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/Makefile \
        --replace -Wl,-soname, -Wl,-install_name,$out/lib/
  '';

  makeFlags = [ "PREFIX=$(out)" "CXX=${stdenv.cc.targetPrefix}c++" ];

  meta = {
    description = "Cross platform (Linux/FreeBSD/Unix/Win32) streaming socket C++";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
}
