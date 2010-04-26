{ stdenv, fetchurl, lib, cmake, perl, python, pam, consolekit
, qt4, sip, pyqt4, kdelibs, kdepimlibs, kdebindings
, libXi, libXau, libXdmcp, libXtst, libXcomposite, libXdamage, libXScrnSaver
, lm_sensors, libxklavier, libusb, libpthreadstubs, boost
, automoc4, phonon, strigi, soprano, qimageblitz, akonadi, polkit_qt, policykit
}:

stdenv.mkDerivation {
  name = "kdebase-workspace-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdebase-workspace-4.4.2.tar.bz2;
    sha256 = "1g8rnpwpihk6sgvils9cafxz017d23ksg5i9x9275ilydslbsclc";
  };
  buildInputs = [ cmake perl python qt4 pam consolekit sip pyqt4 kdelibs libXtst
    kdepimlibs kdebindings boost libusb stdenv.gcc.libc libXi libXau libXdmcp
    libXcomposite libXdamage libXScrnSaver lm_sensors libxklavier automoc4
    phonon strigi soprano qimageblitz akonadi polkit_qt libpthreadstubs
    policykit ];
  patchPhase=''
    sed -i -e 's|''${PYTHON_SITE_PACKAGES_DIR}|''${CMAKE_INSTALL_PREFIX}/lib/python2.6/site-packages|' \
      plasma/generic/scriptengines/python/CMakeLists.txt
  '';
  meta = {
    description = "KDE Workspace";
    longDescription = "KDE base components that are only required to work with X11 such KDM and KWin";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
