{ stdenv, fetchurl, autoreconfHook, pkgconfig, file, protobufc }:

stdenv.mkDerivation rec {
  name = "libivykis-${version}";

  version = "0.41";

  src = fetchurl {
    url = "mirror://sourceforge/libivykis/${version}/ivykis-${version}.tar.gz";
    sha256 = "1igk3svf36i5xgb6ipc507xpj6zjm4xi9j1j2cdqaachllwlb4rc";
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
