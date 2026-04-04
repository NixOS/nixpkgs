{
  lib,
  buildDunePackage,
  dune_3,
  dune-private-libs,
  re,
}:

buildDunePackage {
  pname = "dune-glob";
  inherit (dune_3) src version;

  duneVersion = "3";

  dontAddPrefix = true;

  propagatedBuildInputs = [
    dune-private-libs
    re
  ];

  meta = {
    inherit (dune_3.meta) homepage;
    description = "Glob string matching language supported by dune";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
