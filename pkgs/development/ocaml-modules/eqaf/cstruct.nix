{
  buildDunePackage,
  eqaf,
  cstruct,
}:

buildDunePackage {
  pname = "eqaf-cstruct";

  inherit (eqaf) src version meta;

  propagatedBuildInputs = [
    cstruct
    eqaf
  ];
}
