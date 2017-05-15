{ mkDerivation, lib, extra-cmake-modules, kcoreaddons, ki18n, kpty
, kservice
}:

mkDerivation {
  name = "kdesu";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kcoreaddons ki18n kpty kservice ];
}
