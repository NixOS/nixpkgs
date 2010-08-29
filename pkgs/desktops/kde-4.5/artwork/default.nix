{ kde, cmake, qt4, perl, xscreensaver
, kdelibs, kdebase_workspace, automoc4, strigi, eigen}:

kde.package {

  buildInputs = [ cmake qt4 perl xscreensaver kdelibs kdebase_workspace automoc4
    strigi eigen ];

  preConfigure = ''
    cp -v ${./FindXscreensaver.cmake} cmake/modules/FindXscreensaver.cmake
    '';

  meta = {
    description = "KDE artwork";
    longDescription = "Contains various artwork for KDE such as backgrounds, icons and screensavers";
    license = "LGPL";
    kde = {
      name = "kdeartwork";
      version = "4.5.0";
    };
  };
}
