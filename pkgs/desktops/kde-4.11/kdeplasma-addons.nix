{ kde, kdelibs, marble, shared_desktop_ontologies, pkgconfig
, boost, eigen, kde_workspace, attica, qca2, qimageblitz
, kdepimlibs, libkexiv2, libqalculate, libXtst, libdbusmenu_qt
, qjson, qoauth }:

kde {

# TODO: qwt, scim, ibus

  KDEDIRS=marble;

  buildInputs = [ kdelibs boost kde_workspace kdepimlibs attica qjson qoauth
                  eigen qca2 libXtst qimageblitz libqalculate 
                  shared_desktop_ontologies marble libkexiv2 libdbusmenu_qt
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "KDE Plasma Addons";
    license = "GPL";
  };
}
