{ buildDunePackage, dolmen, dolmen_type
, gen
}:

buildDunePackage {
  pname = "dolmen_loop";
  inherit (dolmen) src version;

  propagatedBuildInputs = [ dolmen dolmen_type gen ];

  meta = dolmen.meta // {
    description = "A tool library for automated deduction tools";
  };
}
