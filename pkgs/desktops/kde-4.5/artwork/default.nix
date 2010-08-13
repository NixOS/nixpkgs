{ kdePackage, cmake, qt4, perl, xscreensaver
, kdelibs, kdebase_workspace, automoc4, strigi, eigen}:

kdePackage {
  pn = "kdeartwork";
  v = "4.5.0";

  buildInputs = [ cmake qt4 perl xscreensaver kdelibs kdebase_workspace automoc4
    strigi eigen ];

  preConfigure = ''
    cp -v ${./FindXscreensaver.cmake} cmake/modules/FindXscreensaver.cmake
    '';

  meta = {
    description = "KDE artwork";
    longDescription = "Contains various artwork for KDE such as backgrounds, icons and screensavers";
    license = "LGPL";
  };
}
