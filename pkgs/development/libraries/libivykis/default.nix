{ stdenv, fetchurl, autoreconfHook, pkgconfig, file, protobufc }:

stdenv.mkDerivation rec {
  name = "libivykis-${version}";

  version = "0.42.2";

  src = fetchurl {
    url = "mirror://sourceforge/libivykis/${version}/ivykis-${version}.tar.gz";
    sha256 = "14vb613j4xas70wr7g5z9c9z871xhayd4zliywwf88myd41jcsw8";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ file protobufc ];

  meta = with stdenv.lib; {
    homepage = http://libivykis.sourceforge.net/;
    description = ''
      A thin wrapper over various OS'es implementation of I/O readiness
      notification facilities
    '';
    license = licenses.zlib;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}
