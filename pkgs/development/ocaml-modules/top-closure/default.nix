{ buildDunePackage, dune_3 }:

buildDunePackage {
  pname = "top-closure";
  inherit (dune_3) version src;

  dontAddPrefix = true;

  meta = dune_3.meta // {
    description = "Dune's topological closure library";
  };
}
