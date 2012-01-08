{ kde, kdelibs, xscreensaver, kde_workspace, eigen, libkexiv2 }:

kde {
  buildInputs = [ kdelibs xscreensaver kde_workspace eigen libkexiv2 ];

  preConfigure = "cp -v ${./FindXscreensaver.cmake} cmake/modules/FindXscreensaver.cmake";

  cmakeFlags = [ "-DBUILD_asciiquarium:BOOL=ON" ];

  meta = {
    description = "KDE screensavers";
  };
}
