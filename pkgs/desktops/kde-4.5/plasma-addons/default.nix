{ kdePackage, cmake, qt4, perl, automoc4, kdelibs, soprano, kdeedu
, boost, eigen, kdebase_workspace, attica, python, qca2, qimageblitz
, shared_mime_info, kdepimlibs, kdegraphics, libqalculate, libXtst }:
# TODO: qwt, scim, MARBLE!!

kdePackage {
  pn = "kdeplasma-addons";
  v = "4.5.0";

  buildInputs = [ cmake qt4 perl automoc4 kdelibs boost eigen kdebase_workspace
    attica python qca2 qimageblitz shared_mime_info kdepimlibs kdegraphics
    libqalculate soprano libXtst kdeedu ];

  meta = {
    description = "KDE Plasma Addons";
    license = "GPL";
  };
}
