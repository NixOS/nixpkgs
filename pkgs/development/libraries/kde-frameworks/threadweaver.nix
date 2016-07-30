{ kdeFramework, lib
, ecm
}:

kdeFramework {
  name = "threadweaver";
  nativeBuildInputs = [ ecm ];
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
}
