{
  buildDunePackage,
  dolmen,
  dolmen_type,
  gen,
  pp_loc,
  mdx,
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

  doCheck = true;
  nativeCheckInputs = [ mdx.bin ];
  checkInputs = [ mdx ];

  meta = dolmen.meta // {
    description = "Tool library for automated deduction tools";
  };
}
