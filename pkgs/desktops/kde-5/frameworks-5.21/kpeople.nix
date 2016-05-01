{ kdeFramework, lib, extra-cmake-modules, kcoreaddons, ki18n
, kitemviews, kservice, kwidgetsaddons, qtdeclarative
}:

kdeFramework {
  name = "kpeople";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kcoreaddons ki18n kitemviews kservice kwidgetsaddons qtdeclarative
  ];
}
