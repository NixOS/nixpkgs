{
  buildDunePackage,
  dolmen,
  spelll,
  uutf,
}:

buildDunePackage {
  pname = "dolmen_type";
  inherit (dolmen) src version;

  propagatedBuildInputs = [
    dolmen
    spelll
    uutf
  ];

  meta = dolmen.meta // {
    description = "A typechecker for automated deduction languages";
  };
}
