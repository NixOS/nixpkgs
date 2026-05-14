{ buildDunePackage, dune_3 }:

buildDunePackage {
  pname = "fs-io";
  inherit (dune_3) version src;

  dontAddPrefix = true;

  meta = dune_3.meta // {
    description = "Dune's file system IO library";
  };
}
