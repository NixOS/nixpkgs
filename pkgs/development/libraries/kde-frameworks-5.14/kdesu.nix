{ kdeFramework, lib
, extra-cmake-modules
, kcoreaddons
, ki18n
, kpty
, kservice
}:

kdeFramework {
  name = "kdesu";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons ki18n kservice ];
  propagatedBuildInputs = [ kpty ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
