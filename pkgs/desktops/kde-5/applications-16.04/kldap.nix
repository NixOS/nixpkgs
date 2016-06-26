{ cyrus_sasl
, extra-cmake-modules
, kcompletion
, kdeApp
, ki18n
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
    extra-cmake-modules
  ];
  buildInputs = [
    cyrus_sasl
    kcompletion
    ki18n
    openldap
  ];
}
