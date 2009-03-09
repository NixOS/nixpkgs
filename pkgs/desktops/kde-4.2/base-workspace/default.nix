{stdenv, fetchurl, cmake, perl, python,
 qt4, sip, pyqt4, kdelibs, kdepimlibs, kdebindings,
 libXi, libXau, libXdmcp, libXtst, libXcomposite, libXdamage, libXScrnSaver,
 lm_sensors, libxklavier, libusb, pthread_stubs, boost,
 automoc4, phonon, strigi, soprano, qimageblitz}:

stdenv.mkDerivation {
  name = "kdebase-workspace-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdebase-workspace-4.2.1.tar.bz2;
    sha1 = "412b8a6778d5c71a366c054b0136edae309bbef0";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake perl python qt4 /*sip pyqt4*/ kdelibs kdepimlibs /*kdebindings*/ pthread_stubs boost libusb stdenv.gcc.libc
                  libXi libXau libXdmcp libXtst libXcomposite libXdamage libXScrnSaver
                  lm_sensors libxklavier automoc4 phonon strigi soprano qimageblitz ];
}
