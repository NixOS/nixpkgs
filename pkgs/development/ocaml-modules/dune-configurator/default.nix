{
  lib,
  buildDunePackage,
  dune_3,
  csexp,
}:

buildDunePackage {
  pname = "dune-configurator";

  inherit (dune_3) src version patches;

  minimalOCamlVersion = "4.05";

  dontAddPrefix = true;

  propagatedBuildInputs = [ csexp ];

  meta = {
    description = "Helper library for gathering system configuration";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
