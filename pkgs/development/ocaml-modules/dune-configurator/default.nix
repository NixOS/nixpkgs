{ lib, buildDunePackage, dune_3, csexp }:

buildDunePackage rec {
  pname = "dune-configurator";

  inherit (dune_3) src version patches;

  # This fixes finding csexp
  postPatch = ''
    rm -rf vendor/pp vendor/csexp
  '';

  minimalOCamlVersion = "4.05";

  dontAddPrefix = true;

  propagatedBuildInputs = [ csexp ];

  meta = with lib; {
    description = "Helper library for gathering system configuration";
    maintainers = [ ];
    license = licenses.mit;
  };
}
