{ kde, kdelibs, marble, shared_desktop_ontologies, pkgconfig
, boost, eigen, kde_workspace, attica, python, qca2, qimageblitz
, kdepimlibs, libkexiv2, libqalculate, libXtst, libdbusmenu_qt }:
# TODO: qwt, scim

kde {

  KDEDIRS=marble;

  buildInputs = [ kdelibs boost eigen kde_workspace
    attica python qca2 qimageblitz kdepimlibs libdbusmenu_qt
    libqalculate libXtst shared_desktop_ontologies marble libkexiv2];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "KDE Plasma Addons";
    license = "GPL";
  };
}
