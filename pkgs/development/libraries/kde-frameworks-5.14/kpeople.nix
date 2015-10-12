{ kdeFramework, lib
, extra-cmake-modules
, kcoreaddons
, ki18n
, kitemviews
, kservice
, kwidgetsaddons
, qtdeclarative
}:

kdeFramework {
  name = "kpeople";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons ki18n kitemviews kservice kwidgetsaddons qtdeclarative
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
