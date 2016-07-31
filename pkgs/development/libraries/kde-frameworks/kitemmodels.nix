{ kdeFramework, lib
, ecm
}:

kdeFramework {
  name = "kitemmodels";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
}
