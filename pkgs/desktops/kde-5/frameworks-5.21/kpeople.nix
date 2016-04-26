{ kdeFramework, lib, extra-cmake-modules, kcoreaddons, ki18n
, kitemviews, kservice, kwidgetsaddons, qtdeclarative
}:

kdeFramework {
  name = "kpeople";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons kitemviews kservice kwidgetsaddons
  ];
  propagatedBuildInputs = [ ki18n qtdeclarative ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
