{ buildDunePackage, dune }:

buildDunePackage {
  pname = "ordering";
  inherit (dune) version src;

  dontAddPrefix = true;

  meta = dune.meta // {
    description = "Element ordering";
  };
}
