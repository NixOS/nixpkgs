{ kde, cmake, qt4, perl, automoc4, kdelibs, soprano, kdeedu
, boost, eigen, kdebase_workspace, attica, python, qca2, qimageblitz
, shared_mime_info, kdepimlibs, kdegraphics, libqalculate, libXtst }:
# TODO: qwt, scim, MARBLE!!

kde.package {

  preConfigure =
    "cp -v ${kdeedu}/share/apps/cmake/modules/FindMarble.cmake cmake";

  buildInputs = [ cmake qt4 perl automoc4 kdelibs boost eigen kdebase_workspace
    attica python qca2 qimageblitz shared_mime_info kdepimlibs kdegraphics
    libqalculate soprano libXtst kdeedu ];

  meta = {
    description = "KDE Plasma Addons";
    license = "GPL";
    kde = {
      name = "kdeplasma-addons";
      version = "4.5.2";
    };
  };
}
