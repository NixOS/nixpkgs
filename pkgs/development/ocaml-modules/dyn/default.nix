{ buildDunePackage, dune_3, ordering }:

buildDunePackage {
  pname = "dyn";
  inherit (dune_3) version src;
  duneVersion = "3";

  dontAddPrefix = true;

  propagatedBuildInputs = [ ordering ];

  meta = dune_3.meta // {
    description = "Dynamic type";
  };
}

