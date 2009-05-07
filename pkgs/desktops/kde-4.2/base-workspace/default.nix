{stdenv, fetchurl, cmake, perl, python, pam, ConsoleKit,
 qt4, sip, pyqt4, kdelibs, kdepimlibs, kdebindings,
 libXi, libXau, libXdmcp, libXtst, libXcomposite, libXdamage, libXScrnSaver,
 lm_sensors, libxklavier, libusb, pthread_stubs, boost,
 automoc4, phonon, strigi, soprano, qimageblitz}:

stdenv.mkDerivation {
  name = "kdebase-workspace-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdebase-workspace-4.2.3.tar.bz2;
    sha1 = "0c92579c651c5a08ff6440762eb5c2ad9d5bc0ad";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake perl python qt4 pam /*ConsoleKit sip pyqt4*/ kdelibs kdepimlibs /*kdebindings*/ pthread_stubs boost libusb stdenv.gcc.libc
                  libXi libXau libXdmcp libXtst libXcomposite libXdamage libXScrnSaver
                  lm_sensors libxklavier automoc4 phonon strigi soprano qimageblitz ];
}
