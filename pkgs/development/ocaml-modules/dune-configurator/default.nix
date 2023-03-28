{ lib, buildDunePackage, dune_3, csexp }:

buildDunePackage rec {
  pname = "dune-configurator";

  inherit (dune_3) src version;

  # This fixes finding csexp
  postPatch = ''
    rm -rf ./vendor
  '';

  minimumOCamlVersion = "4.04";

  duneVersion = "3";
  dontAddPrefix = true;

  propagatedBuildInputs = [ csexp ];

  meta = with lib; {
    description = "Helper library for gathering system configuration";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
