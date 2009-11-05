{ stdenv, fetchurl, lib, cmake, perl, python, pam, ConsoleKit
, qt4, sip, pyqt4, kdelibs, kdelibs_experimental, kdepimlibs, kdebindings
, libXi, libXau, libXdmcp, libXtst, libXcomposite, libXdamage, libXScrnSaver
, lm_sensors, libxklavier, libusb, libpthreadstubs, boost
, automoc4, phonon, strigi, soprano, qimageblitz, akonadi, polkit_qt
}:

stdenv.mkDerivation {
  name = "kdebase-workspace-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdebase-workspace-4.3.3.tar.bz2;
    sha1 = "kl5brn6c2nahxmavd38fmy6frq9yjf98";
  };
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  inherit kdelibs_experimental;
  builder = ./builder.sh;
  buildInputs = [ cmake perl python qt4 pam /*ConsoleKit sip pyqt4*/ kdelibs kdelibs_experimental kdepimlibs /*kdebindings*/ libpthreadstubs boost libusb stdenv.gcc.libc
                  libXi libXau libXdmcp libXtst libXcomposite libXdamage libXScrnSaver
                  lm_sensors libxklavier automoc4 phonon strigi soprano qimageblitz akonadi polkit_qt ];
  meta = {
    description = "KDE Workspace";
    longDescription = "KDE base components that are only required to work with X11 such KDM and KWin";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
