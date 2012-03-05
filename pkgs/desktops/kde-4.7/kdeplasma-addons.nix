{ kde, kdelibs, marble, shared_desktop_ontologies, pkgconfig
, boost, eigen, kde_workspace, attica, python, qca2, qimageblitz
, kdepimlibs, libkexiv2, libqalculate, libXtst }:
# TODO: qwt, scim

kde {

  KDEDIRS=marble;

  buildInputs = [ kdelibs boost eigen kde_workspace
    attica python qca2 qimageblitz kdepimlibs
    libqalculate libXtst shared_desktop_ontologies marble libkexiv2];

  buildNativeInputs = [ pkgconfig ];

  meta = {
    description = "KDE Plasma Addons";
    license = "GPL";
  };
}
