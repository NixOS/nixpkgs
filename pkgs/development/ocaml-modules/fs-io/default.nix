{ buildDunePackage, dune }:

buildDunePackage {
  pname = "fs-io";
  inherit (dune) version src;

  dontAddPrefix = true;

  meta = dune.meta // {
    description = "Dune's file system IO library";
  };
}
