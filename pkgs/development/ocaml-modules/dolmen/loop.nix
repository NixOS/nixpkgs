{
  buildDunePackage,
  dolmen,
  dolmen_type,
  gen,
  pp_loc,
}:

buildDunePackage {
  pname = "dolmen_loop";
  inherit (dolmen) src version;

  propagatedBuildInputs = [
    dolmen
    dolmen_type
    gen
    pp_loc
  ];

  meta = dolmen.meta // {
    description = "Tool library for automated deduction tools";
  };
}
