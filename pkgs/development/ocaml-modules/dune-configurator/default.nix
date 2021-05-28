{ lib, buildDunePackage, dune_2, csexp, result }:

buildDunePackage rec {
  pname = "dune-configurator";

  useDune2 = true;

  inherit (dune_2) src version patches;

  minimumOCamlVersion = "4.03";

  dontAddPrefix = true;

  propagatedBuildInputs = [ csexp result ];

  meta = with lib; {
    description = "Helper library for gathering system configuration";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
