{ stdenv, fetchurl, lib, cmake, perl, python, pam, ConsoleKit
, qt4, sip, pyqt4, kdelibs, kdepimlibs,
, libXi, libXau, libXdmcp, libXtst, libXcomposite, libXdamage, libXScrnSaver
, lm_sensors, libxklavier, libusb, libpthreadstubs, boost
, automoc4, phonon, strigi, soprano, qimageblitz, akonadi, polkit_qt
}:

stdenv.mkDerivation {
  name = "kdebase-workspace-4.4.0";
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/kdebase-workspace-4.4.0.tar.bz2;
    sha256 = "16rc4cpq97bfcvj0bmq9k3kv48gjbx8569m7lg3qm91xg8nz79hn";
  };
  buildInputs = [ cmake perl python qt4 pam /*ConsoleKit sip pyqt4*/ kdelibs kdepimlibs /*kdebindings*/ libpthreadstubs boost libusb stdenv.gcc.libc
                  libXi libXau libXdmcp libXtst libXcomposite libXdamage libXScrnSaver
                  lm_sensors libxklavier automoc4 phonon strigi soprano qimageblitz akonadi polkit_qt ];
  meta = {
    description = "KDE Workspace";
    longDescription = "KDE base components that are only required to work with X11 such KDM and KWin";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
