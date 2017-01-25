{ stdenv, fetchurl, autoreconfHook, pkgconfig, file, protobufc }:

stdenv.mkDerivation rec {
  name = "libivykis-${version}";

  version = "0.40";

  src = fetchurl {
    url = "mirror://sourceforge/libivykis/${version}/ivykis-${version}.tar.gz";
    sha256 = "1rn32dijv0pn9y2mbdg1n7al4h4i5pwwhhihr9pyakwyb6qgmqxj";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ file protobufc ];

  meta = with stdenv.lib; {
    homepage = "http://libivykis.sourceforge.net/";
    description = ''
      A thin wrapper over various OS'es implementation of I/O readiness
      notification facilities
    '';
    license = licenses.zlib;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}
