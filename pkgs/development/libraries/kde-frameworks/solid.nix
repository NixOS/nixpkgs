{
  kdeFramework, lib,
  bison, ecm, flex,
  qtdeclarative
}:

kdeFramework {
  name = "solid";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ bison ecm flex ];
  propagatedBuildInputs = [ qtdeclarative ];
}
