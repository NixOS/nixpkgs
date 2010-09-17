{ kde, cmake, perl, qt4, kdelibs, pciutils, libraw1394 , automoc4, strigi
, qimageblitz, soprano}:

kde.package {
  preConfigure = "cd apps";

  buildInputs = [ cmake perl qt4 kdelibs pciutils libraw1394 automoc4
    strigi qimageblitz ];

  meta = {
    description = "KDE Base components";
    longDescription = "Applications that form the KDE desktop, like Plasma, System Settings, Konqueror, Dolphin, Kate, and Konsole";
    license = "GPL";
    kde = {
      name = "kdebase";
      version = "4.5.1";
    };
  };
}
