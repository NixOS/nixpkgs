{ kdeFramework, lib, extra-cmake-modules, kcoreaddons, ki18n, kpty
, kservice
}:

kdeFramework {
  name = "kdesu";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons kservice ];
  propagatedBuildInputs = [ ki18n kpty ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
