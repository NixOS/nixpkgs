{ stdenv, fetchurl, pkgconfig, libsigcxx }:

stdenv.mkDerivation rec {
  name = "libpar2-0.2";

  src = fetchurl {
    url = "mirror://sourceforge/parchive/${name}.tar.gz";
    sha256 = "024r37wi01d1pfkk17l5lk0ci0cc0xhy5z050hzf3cbk1y2bykq7";
  };

  buildInputs = [ pkgconfig libsigcxx ];

  meta = {
    homepage = http://parchive.sourceforge.net/;
    license = "GPLv2+";
    description = "A library for using Parchives (parity archive volume sets)";
  };
}
