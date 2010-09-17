{ cmake, kde, automoc4, kdelibs, xscreensaver, kdebase_workspace, eigen }:

kde.package rec {
  buildInputs = [ cmake automoc4 kdelibs xscreensaver kdebase_workspace eigen ];
  preConfigure = "cp -v ${./FindXscreensaver.cmake} cmake/modules/FindXscreensaver.cmake";
  meta = {
    description = "KDE screen saver and savers";
    kde = {
      name = "kscreensaver";
      module = "kdeartwork";
      version = "1.0";
      release = "4.5.1";
    };
  };
}
