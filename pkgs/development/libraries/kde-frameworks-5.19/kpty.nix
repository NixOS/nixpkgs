{ kdeFramework, lib, extra-cmake-modules, kcoreaddons, ki18n }:

kdeFramework {
  name = "kpty";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kcoreaddons ki18n ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
