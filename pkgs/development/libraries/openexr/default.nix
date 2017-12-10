{ lib, stdenv, fetchurl, fetchpatch, autoconf, automake, libtool, pkgconfig, zlib, ilmbase }:

stdenv.mkDerivation rec {
  name = "openexr-${lib.getVersion ilmbase}";

  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/openexr/${name}.tar.gz";
    sha256 = "0ca2j526n4wlamrxb85y2jrgcv0gf21b3a19rr0gh4rjqkv1581n";
  };

  patches = [
    ./bootstrap.patch
    (fetchpatch {
      # https://github.com/openexr/openexr/issues/232
      # https://github.com/openexr/openexr/issues/238
      name = "CVE-2017-12596.patch";
      url = "https://github.com/openexr/openexr/commit/f09f5f26c1924.patch";
      sha256 = "1d014da7c8cgbak5rgr4mq6wzm7kwznb921pr7nlb52vlfvqp4rs";
      stripLen = 1;
    })
  ];

  outputs = [ "bin" "dev" "out" "doc" ];

  preConfigure = ''
    ./bootstrap
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libtool ];
  propagatedBuildInputs = [ ilmbase zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.openexr.com/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
