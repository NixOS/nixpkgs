{ plasmaPackage, ecm, qtscript, qtdeclarative
, kcoreaddons, ki18n, kdeclarative, kservice, plasma-framework
, krunner
}:

plasmaPackage {
  name = "milou";
  nativeBuildInputs = [
    ecm
  ];
  propagatedBuildInputs = [
    kdeclarative ki18n krunner plasma-framework qtdeclarative qtscript
    kcoreaddons kservice
  ];
}
