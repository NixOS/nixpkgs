{ stdenv, fetchurl, autoreconfHook, pkgconfig, file, protobufc }:

stdenv.mkDerivation rec {
  name = "libivykis-${version}";

  version = "0.42.3";

  src = fetchurl {
    url = "mirror://sourceforge/libivykis/${version}/ivykis-${version}.tar.gz";
    sha256 = "1v0ajkm531v4zxzn2x90yb5ab81ssqv2y0fib24wbsggbkajbc69";
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
