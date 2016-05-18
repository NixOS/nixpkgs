{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, kconfig
, kio
, ki18n
, kservice
, kfilemetadata
, baloo
, kdelibs4support
}:

kdeApp {
  name = "baloo-widgets";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    baloo kconfig kservice kdelibs4support kfilemetadata ki18n kio
  ];
}
