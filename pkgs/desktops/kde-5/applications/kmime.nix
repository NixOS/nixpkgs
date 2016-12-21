{
  kdeApp, lib,
  ecm, ki18n,
  kcodecs
}:

kdeApp {
  name = "kmime";
  meta = {
    license = [ lib.licenses.lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm ki18n ];
  buildInputs = [ kcodecs ];
}
