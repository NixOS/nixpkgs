{ cyrus_sasl
, extra-cmake-modules
, kcoreaddons
, kdeApp
, ki18n
, kio
, kmime
, lib
}:

kdeApp {
  name = "kimap";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    cyrus_sasl
    kcoreaddons
    ki18n
    kio
    kmime
  ];
}
