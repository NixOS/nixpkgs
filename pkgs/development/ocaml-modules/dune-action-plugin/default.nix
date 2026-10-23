{
  lib,
  buildDunePackage,
  dune,
  dune-glob,
  dune-private-libs,
  dune-rpc,
}:

buildDunePackage {
  pname = "dune-action-plugin";
  inherit (dune) src version;

  dontAddPrefix = true;

  propagatedBuildInputs = [
    dune-glob
    dune-private-libs
    dune-rpc
  ];

  meta = {
    inherit (dune.meta) homepage;
    description = "API for writing dynamic Dune actions";
    maintainers = [ ];
    license = lib.licenses.mit;
    hasNoMaintainersButDependents = true;
  };
}
