{
  lib,
  buildDunePackage,
  dune,
  dune-private-libs,
  re,
}:

buildDunePackage {
  pname = "dune-glob";
  inherit (dune) src version;

  dontAddPrefix = true;

  propagatedBuildInputs = [
    dune-private-libs
    re
  ];

  meta = {
    inherit (dune.meta) homepage;
    description = "Glob string matching language supported by dune";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
