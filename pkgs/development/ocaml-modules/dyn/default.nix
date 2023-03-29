{ lib, buildDunePackage, dune_3, ordering }:

buildDunePackage {
  pname = "dyn";
  inherit (dune_3) version src;

  dontAddPrefix = true;

  propagatedBuildInputs = [ ordering ];

  meta = dune_3.meta // {
    description = "Dynamic type";
  };
}

