{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, kcoreaddons
, ki18n
, kio
, kwidgetsaddons
, samba
}:

kdeApp {
  name = "kdenetwork-filesharing";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcoreaddons
    ki18n
    kio
    kwidgetsaddons
    samba
  ];
  meta = {
    license = [ lib.licenses.gpl2 lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
