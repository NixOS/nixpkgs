{ kde, cmake, perl, python, pam, consolekit
, qt4, sip, pyqt4, kdelibs, kdepimlibs, kdebindings
, libXi, libXau, libXdmcp, libXtst, libXcomposite, libXdamage, libXScrnSaver
, lm_sensors, libxklavier, libusb, libpthreadstubs, boost
, automoc4, strigi, soprano, qimageblitz, akonadi
, libdbusmenu_qt, libqalculate, pciutils, libraw1394, bluez
}:

kde.package {

# TODO: qedje, qzion, ggadgets, libgps
  buildInputs = [ cmake perl python qt4 pam consolekit sip pyqt4 kdelibs libXtst
    kdepimlibs kdebindings boost libusb libXi libXau libXdmcp libraw1394
    libXcomposite libXdamage libXScrnSaver lm_sensors libxklavier automoc4
    strigi soprano qimageblitz akonadi libpthreadstubs libdbusmenu_qt libqalculate
    pciutils bluez ];

  meta = {
    description = "KDE base platform-specific components";
    longDescription = "KDE base components that are only required to work with X11 such KDM and KWin";
    license = "GPL";
    kde = {
      name = "kdebase-workspace";
      version = "4.5.2";
    };
  };
}
