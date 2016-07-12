{ kdeFramework, lib, extra-cmake-modules, kcoreaddons, ki18n, kpty
, kservice
}:

kdeFramework {
  name = "kdesu";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kcoreaddons ki18n kpty kservice ];
}
