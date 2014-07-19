{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, file, protobufc }:

stdenv.mkDerivation rec {
  name = "libivykis-${version}";

  version = "0.39";

  src = fetchurl {
    url = "mirror://sourceforge/libivykis/${version}/ivykis-${version}.tar.gz";
    sha256 = "11d7sjbhcll932rlvx9sf3vk60b5bazmjf4vlr4qd9cz0cashizz";
  };

  buildInputs = [ autoconf automake libtool pkgconfig file protobufc ];

  preConfigure = "autoreconf -i";

  meta = with stdenv.lib; {
    description = ''
      A thin wrapper over various OS'es implementation of I/O readiness
      notification facilities
    '';
    license = licenses.zlib;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}
