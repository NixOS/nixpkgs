{
  lib,
  buildDunePackage,
  dune,
  csexp,
}:

buildDunePackage {
  pname = "dune-configurator";

  inherit (dune) src version;

  dontAddPrefix = true;

  propagatedBuildInputs = [ csexp ];

  meta = {
    description = "Helper library for gathering system configuration";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
