{ cmake, kde, qt4, automoc4, kdelibs, phonon, xscreensaver, kde_workspace, eigen, libkexiv2 }:

kde.package rec {
  buildInputs =
    [ cmake automoc4 qt4 kdelibs phonon xscreensaver kde_workspace eigen libkexiv2 ];
  
  preConfigure = "cp -v ${./FindXscreensaver.cmake} cmake/modules/FindXscreensaver.cmake";
  
  meta = {
    description = "KDE screensavers";
    kde = {
      name = "kscreensaver";
      module = "kdeartwork";
      version = "1.0";
      versionFile = "kscreensaver/kpartsaver/kpartsaver.cpp";
    };
  };
}
