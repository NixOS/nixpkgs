{stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, mysql, automoc4}:

stdenv.mkDerivation {
  name = "akonadi-1.1.2";
  src = fetchurl {
    url = http://download.akonadi-project.org/akonadi-1.1.2.tar.bz2;
    sha256 = "1km5mbcsx8xbb327lbva1pm8a8mjai64kqxww1qzbxz9a20w3css";
  };
  buildInputs = [ cmake qt4 shared_mime_info libxslt boost mysql automoc4 ];
}
