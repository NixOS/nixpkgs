{stdenv, fetchurl, lib, cmake, qt4, shared_mime_info, libxslt, boost, mysql, automoc4, soprano}:

stdenv.mkDerivation {
  name = "akonadi-1.3.1";
  src = fetchurl {
    url = http://download.akonadi-project.org/akonadi-1.3.1.tar.bz2;
    sha256 = "1pbn6sviipxxpx80cspncfc3nlz047nryfbv8xzfz5811p19k7jb";
  };
  patchPhase = ''
    cp ${cmake}/share/cmake-${cmake.majorVersion}/Modules/FindQt4.cmake cmake/modules
  '';
  buildInputs = [ cmake qt4 shared_mime_info libxslt boost mysql automoc4 soprano ];
  meta = {
    description = "KDE PIM Storage Service";
    license = "LGPL";
    homepage = http://pim.kde.org/akonadi;
    maintainers = [ lib.maintainers.sander ];
  };
}
