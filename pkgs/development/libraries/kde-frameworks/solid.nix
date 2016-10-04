{ kdeFramework, lib
, ecm
, qtdeclarative
}:

kdeFramework {
  name = "solid";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ qtdeclarative ];
}
