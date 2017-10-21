{ stdenv, fetchurl }:
 
stdenv.mkDerivation rec {
  name = "libpipeline-1.4.1";
  
  src = fetchurl {
    url = "mirror://savannah/libpipeline/${name}.tar.gz";
    sha256 = "1vmrs4nvdsmb550bk10cankrd42ffczlibpsnafxpak306rdfins";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./fix-on-osx.patch ];

  meta = with stdenv.lib; {
    homepage = http://libpipeline.nongnu.org;
    description = "C library for manipulating pipelines of subprocesses in a flexible and convenient way";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
