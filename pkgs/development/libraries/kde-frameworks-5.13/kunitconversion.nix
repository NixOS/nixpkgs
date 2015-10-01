{ kdeFramework, lib
, extra-cmake-modules
, ki18n
}:

kdeFramework {
  name = "kunitconversion";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
