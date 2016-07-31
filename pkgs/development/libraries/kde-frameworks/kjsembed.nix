{ kdeFramework, lib, ecm, kdoctools, ki18n, kjs
, qtsvg
}:

kdeFramework {
  name = "kjsembed";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [ ki18n kjs qtsvg ];
}
