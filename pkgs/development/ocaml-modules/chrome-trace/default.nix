{
  lib,
  buildDunePackage,
  dune,
}:

buildDunePackage {
  pname = "chrome-trace";
  inherit (dune) src version;

  dontAddPrefix = true;

  meta = {
    description = "Chrome trace event generation library";
    inherit (dune.meta) homepage;
    license = lib.licenses.mit;
  };
}
