{ kde, kdelibs, marble, shared_desktop_ontologies, pkgconfig
, boost, eigen2, kde_workspace, attica, qca2, qimageblitz
, kdepimlibs, libkexiv2, libqalculate, libXtst, libdbusmenu_qt
, qjson, qoauth, shared_mime_info }:

kde {

# TODO: qwt, scim, ibus

  KDEDIRS=marble;

  buildInputs = [ kdelibs boost kde_workspace kdepimlibs attica qjson qoauth
                  eigen2 qca2 libXtst qimageblitz libqalculate 
                  shared_desktop_ontologies marble libkexiv2 libdbusmenu_qt
  ];

  nativeBuildInputs = [ shared_mime_info ];

  meta = {
    description = "KDE Plasma Addons";
    license = "GPL";
  };
}
