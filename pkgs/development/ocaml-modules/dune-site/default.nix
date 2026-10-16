{
  lib,
  buildDunePackage,
  dune,
  dune-private-libs,
}:

buildDunePackage {
  pname = "dune-site";
  inherit (dune) src version;

  dontAddPrefix = true;

  propagatedBuildInputs = [ dune-private-libs ];

  meta = {
    description = "Library for embedding location information inside executable and libraries";
    inherit (dune.meta) homepage;
    maintainers = [ ];
    license = lib.licenses.mit;
    hasNoMaintainersButDependents = true;
  };
}
