{ plasmaPackage, extra-cmake-modules, qtscript, qtdeclarative
, kcoreaddons, ki18n, kdeclarative, kservice, plasma-framework
, krunner
}:

plasmaPackage {
  name = "milou";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    qtscript kcoreaddons kservice plasma-framework krunner
  ];
  propagatedBuildInputs = [ kdeclarative ki18n qtdeclarative ];
}
