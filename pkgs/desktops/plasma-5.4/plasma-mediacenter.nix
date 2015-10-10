{ plasmaPackage, extra-cmake-modules, baloo, kactivities, kconfig
, kcoreaddons, kdeclarative, kguiaddons, ki18n, kio, kservice
, kfilemetadata, plasma-framework, qtdeclarative, qtmultimedia
, taglib
}:

plasmaPackage {
  name = "plasma-mediacenter";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kconfig kcoreaddons kguiaddons kio kservice plasma-framework
    qtdeclarative qtmultimedia taglib
  ];
  propagatedBuildInputs = [
    baloo kactivities kdeclarative kfilemetadata ki18n
  ];
}
