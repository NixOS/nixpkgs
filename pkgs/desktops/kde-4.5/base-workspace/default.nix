{ kdePackage, cmake, perl, python, pam, consolekit
, qt4, sip, pyqt4, kdelibs, kdepimlibs, kdebindings
, libXi, libXau, libXdmcp, libXtst, libXcomposite, libXdamage, libXScrnSaver
, lm_sensors, libxklavier, libusb, libpthreadstubs, boost
, automoc4, strigi, soprano, qimageblitz, akonadi
, libdbusmenu_qt
}:

kdePackage {
  pn = "kdebase-workspace";
  v = "4.5.0";

  buildInputs = [ cmake perl python qt4 pam consolekit sip pyqt4 kdelibs libXtst
    kdepimlibs kdebindings boost libusb libXi libXau libXdmcp
    libXcomposite libXdamage libXScrnSaver lm_sensors libxklavier automoc4
    strigi soprano qimageblitz akonadi libpthreadstubs libdbusmenu_qt ];

  meta = {
    description = "KDE Workspace";
    longDescription = "KDE base components that are only required to work with X11 such KDM and KWin";
    license = "GPL";
  };
}
