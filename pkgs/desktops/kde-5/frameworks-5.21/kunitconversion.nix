{ kdeFramework, lib, extra-cmake-modules, ki18n }:

kdeFramework {
  name = "kunitconversion";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ ki18n ];
}
