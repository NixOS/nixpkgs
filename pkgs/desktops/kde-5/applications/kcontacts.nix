{
  kdeApp, lib,
  ecm, ki18n,
  kcoreaddons, kconfig, kcodecs
}:

kdeApp {
  name = "kcontacts";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm ki18n ];
  buildInputs = [ kcoreaddons kconfig kcodecs ];
}
