{ kdeFramework, lib, extra-cmake-modules, kdoctools, ki18n, kjs
, qtsvg
}:

kdeFramework {
  name = "kjsembed";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ ki18n kjs qtsvg ];
}
