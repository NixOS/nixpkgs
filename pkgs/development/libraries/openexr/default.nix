{ lib, stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, zlib, ilmbase }:

stdenv.mkDerivation rec {
  name = "openexr-${lib.getVersion ilmbase}";

  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/openexr/${name}.tar.gz";
    sha256 = "0ca2j526n4wlamrxb85y2jrgcv0gf21b3a19rr0gh4rjqkv1581n";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  preConfigure = ''
    ./bootstrap
  '';

  buildInputs = [ autoconf automake libtool pkgconfig ];
  propagatedBuildInputs = [ ilmbase zlib ];

  enableParallelBuilding = true;

  patches = [ ./bootstrap.patch ];

  meta = with stdenv.lib; {
    homepage = http://www.openexr.com/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
