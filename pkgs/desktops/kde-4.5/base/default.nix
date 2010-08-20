{ kdePackage, cmake, perl, qt4, kdelibs, pciutils, libraw1394
, automoc4, strigi, qimageblitz, soprano}:

kdePackage {
  pn = "kdebase";
  v = "4.5.0";

  preConfigure = "cd apps";

  buildInputs = [ cmake perl qt4 kdelibs pciutils libraw1394 automoc4
    strigi qimageblitz soprano ];

  meta = {
    description = "KDE Base components";
    longDescription = "Applications that form the KDE desktop, like Plasma, System Settings, Konqueror, Dolphin, Kate, and Konsole";
    license = "GPL";
  };
}
