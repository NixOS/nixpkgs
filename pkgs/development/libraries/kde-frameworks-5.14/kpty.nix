{ kdeFramework, lib
, extra-cmake-modules
, kcoreaddons
, ki18n
}:

kdeFramework {
  name = "kpty";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n ];
  propagatedBuildInputs = [ kcoreaddons ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
