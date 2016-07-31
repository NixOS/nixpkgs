{
  kdeApp, lib,
  ecm, kdoctools,
  kcoreaddons, ki18n, kio, kwidgetsaddons, samba
}:

kdeApp {
  name = "kdenetwork-filesharing";
  meta = {
    license = [ lib.licenses.gpl2 lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [ kcoreaddons ki18n kio kwidgetsaddons samba ];
}
