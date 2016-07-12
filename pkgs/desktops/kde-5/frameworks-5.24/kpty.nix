{ kdeFramework, lib, extra-cmake-modules, kcoreaddons, ki18n }:

kdeFramework {
  name = "kpty";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kcoreaddons ki18n ];
}
