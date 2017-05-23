{ cyrus_sasl
, ecm
, kcompletion
, kdeApp
, kdoctools
, ki18n
, kio
, kmbox
, kmime
, lib
, openldap
}:

kdeApp {
  name = "kldap";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    ecm
  ];
  buildInputs = [
    cyrus_sasl
    kcompletion
    kdoctools
    ki18n
    kio
    kmbox
    kmime
    openldap
  ];
}
