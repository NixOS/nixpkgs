{ kde, kdelibs, marble, shared_desktop_ontologies, pkgconfig
, boost, eigen2, kde_workspace, attica, qca2, qimageblitz
, kdepimlibs, libkexiv2, libqalculate, libXtst, libdbusmenu_qt
, qjson, qoauth, ibus }:

kde {

# TODO: qwt, scim

  KDEDIRS=marble;

  buildInputs = [ kdelibs boost kde_workspace kdepimlibs attica qjson qoauth
                  eigen2 qca2 libXtst qimageblitz libqalculate ibus
                  shared_desktop_ontologies marble libkexiv2 libdbusmenu_qt
  ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "KDE Plasma Addons";
    license = "GPL";
  };
}
