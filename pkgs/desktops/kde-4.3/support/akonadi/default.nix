{stdenv, fetchurl, lib, cmake, qt4, shared_mime_info, libxslt, boost, mysql, automoc4, soprano}:

stdenv.mkDerivation {
  name = "akonadi-1.2.1";
  src = fetchurl {
    url = http://download.akonadi-project.org/akonadi-1.2.1.tar.bz2;
    sha256 = "ee2bd0802d8202652388dd78959628716968f974b8f254de7055a0d74cba2134";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 shared_mime_info libxslt boost mysql automoc4 soprano ];
  meta = {
    description = "KDE PIM Storage Service";
    license = "LGPL";
    homepage = http://pim.kde.org/akonadi;
    maintainers = [ lib.maintainers.sander ];
  };
}
