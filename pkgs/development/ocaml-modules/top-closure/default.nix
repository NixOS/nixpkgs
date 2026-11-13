{ buildDunePackage, dune }:

buildDunePackage {
  pname = "top-closure";
  inherit (dune) version src;

  dontAddPrefix = true;

  meta = dune.meta // {
    description = "Dune's topological closure library";
  };
}
