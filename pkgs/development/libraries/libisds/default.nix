{ stdenv, fetchurl, expat, gpgme, libgcrypt, libxml2 }:

stdenv.mkDerivation rec {
  name = "libisds-${version}";
  version = "0.10.8";



  src = fetchurl {
    url = "http://xpisar.wz.cz/libisds/dist/${name}.tar.xz";
    sha256 = "1av6i7acqrsl054mm6hbz20qcnbmxmzbax942c31576f00vwcqbq";
  };

  enableParallelBuilding = true;

  buildInputs = [ expat gpgme libgcrypt ];
  propagatedBuildInputs = [ libxml2 ];

  meta = with stdenv.lib; {
    description = "Client library for accessing SOAP services of Czech government-provided Databox infomation system";
    homepage = "https://xpisar.wz.cz/libisds";
    license = licenses.lgpl3;
    maintainers = [ maintainers.cptMikky ];
    platforms = platforms.all;
  };
}
