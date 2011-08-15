{ kde, kdelibs, kdeedu, shared_desktop_ontologies
, boost, eigen, kde_workspace, attica, python, qca2, qimageblitz
, kdepimlibs, libkexiv2, libqalculate, libXtst }:
# TODO: qwt, scim
# TODO: parts of kdegraphics, kdeedu

kde {

  KDEDIRS=kdeedu.marble;

  buildInputs = [ kdelibs boost eigen kde_workspace
    attica python qca2 qimageblitz kdepimlibs
    libqalculate libXtst shared_desktop_ontologies kdeedu.marble libkexiv2];

  meta = {
    description = "KDE Plasma Addons";
    license = "GPL";
  };
}
