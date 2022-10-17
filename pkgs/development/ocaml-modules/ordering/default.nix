{ lib, buildDunePackage, dune_3 }:

buildDunePackage {
  pname = "ordering";
  inherit (dune_3) version src;
  duneVersion = "3";

  dontAddPrefix = true;

  meta = dune_3.meta // {
    description = "Element ordering";
  };
}
