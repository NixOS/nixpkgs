{ kdeFramework, lib
, ecm
, kdoctools
}:

kdeFramework {
  name = "kjs";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm kdoctools ];
}
