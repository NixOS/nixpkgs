{ stdenv, fetchurl, lib, cmake, perl, python, pam, ConsoleKit
, qt4, sip, pyqt4, kdelibs, kdelibs_experimental, kdepimlibs, kdebindings
, libXi, libXau, libXdmcp, libXtst, libXcomposite, libXdamage, libXScrnSaver
, lm_sensors, libxklavier, libusb, pthread_stubs, boost
, automoc4, phonon, strigi, soprano, qimageblitz, akonadi
}:

stdenv.mkDerivation {
  name = "kdebase-workspace-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdebase-workspace-4.3.1.tar.bz2;
    sha1 = "c21a6e8028aa993878cccccb26b2611b3337eac9";
  };
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  inherit kdelibs_experimental;
  builder = ./builder.sh;
  buildInputs = [ cmake perl python qt4 pam /*ConsoleKit sip pyqt4*/ kdelibs kdelibs_experimental kdepimlibs /*kdebindings*/ pthread_stubs boost libusb stdenv.gcc.libc
                  libXi libXau libXdmcp libXtst libXcomposite libXdamage libXScrnSaver
                  lm_sensors libxklavier automoc4 phonon strigi soprano qimageblitz akonadi ];
  meta = {
    description = "KDE Workspace";
    longDescription = "KDE base components that are only required to work with X11 such KDM and KWin";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
