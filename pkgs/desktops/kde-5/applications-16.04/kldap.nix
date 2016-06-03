{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, kcompletion
, kwidgetsaddons
, openldap
, cyrus_sasl
}:

kdeApp {
  name = "kldap";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    kcompletion
    kwidgetsaddons
    openldap
    cyrus_sasl
  ];

  propagatedBuildInputs = [
    cyrus_sasl
  ];

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
