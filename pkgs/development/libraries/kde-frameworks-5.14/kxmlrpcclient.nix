{ kdeFramework, lib
, extra-cmake-modules
, ki18n
, kio
}:

kdeFramework {
  name = "kxmlrpcclient";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n ];
  propagatedBuildInputs = [ kio ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
