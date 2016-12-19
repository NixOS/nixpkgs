{ kdeFramework, lib
, ecm
}:

kdeFramework {
  name = "kplotting";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
}
