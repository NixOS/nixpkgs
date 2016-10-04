{ kdeFramework, lib, ecm, kcoreaddons, ki18n, kpty
, kservice
}:

kdeFramework {
  name = "kdesu";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ kcoreaddons ki18n kpty kservice ];
}
