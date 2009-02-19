{stdenv, fetchurl, cmake, perl, python,
 qt4, kdelibs, kdepimlibs,
 libXi, libXau, libXdmcp, libXtst, libXcomposite, libXdamage,
 lm_sensors, libxklavier, libusb, pthread_stubs, boost,
 automoc4, phonon, strigi, soprano, qimageblitz}:

stdenv.mkDerivation {
  name = "kdebase-workspace-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdebase-workspace-4.2.0.tar.bz2;
    md5 = "193e30b9ed0b55b0196289d9df43a904";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake perl python qt4 kdelibs kdepimlibs pthread_stubs boost libusb stdenv.gcc.libc
                  libXi libXau libXdmcp libXtst libXcomposite libXdamage
                  lm_sensors libxklavier automoc4 phonon strigi soprano qimageblitz ];
}
