{
  kdeFramework, lib,
  bison, extra-cmake-modules, flex,
  qtdeclarative, qttools
}:

kdeFramework {
  name = "solid";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ bison extra-cmake-modules flex qttools ];
  propagatedBuildInputs = [ qtdeclarative ];
}
