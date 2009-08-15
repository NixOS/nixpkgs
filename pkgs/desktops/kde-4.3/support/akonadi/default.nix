{stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, mysql, automoc4}:

stdenv.mkDerivation {
  name = "akonadi-1.2.0";
  src = fetchurl {
    url = http://download.akonadi-project.org/akonadi-1.2.0.tar.bz2;
    sha256 = "16kx5pfkspaz5000sz9f85xnk33xpssk6ym9wz5z6n3scihwhn6g";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 shared_mime_info libxslt boost mysql automoc4 ];
}
