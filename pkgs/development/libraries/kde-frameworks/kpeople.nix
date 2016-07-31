{ kdeFramework, lib, ecm, kcoreaddons, ki18n
, kitemviews, kservice, kwidgetsaddons, qtdeclarative
}:

kdeFramework {
  name = "kpeople";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    kcoreaddons ki18n kitemviews kservice kwidgetsaddons qtdeclarative
  ];
}
