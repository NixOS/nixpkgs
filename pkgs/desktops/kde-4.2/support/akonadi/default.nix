{stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, mysql, automoc4}:

stdenv.mkDerivation {
  name = "akonadi-1.1.1";
  src = fetchurl {
    url = http://akonadi.omat.nl/akonadi-1.1.1.tar.bz2;
    md5 = "2e98b42cec9ec4e60a2e3c096f1a3106";
  };
  buildInputs = [ cmake qt4 shared_mime_info libxslt boost mysql automoc4 ];
}
