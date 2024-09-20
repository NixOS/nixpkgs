{ lib, buildDunePackage, dune_3, stdune }:

buildDunePackage rec {
  pname = "dune-private-libs";

  duneVersion = "3";

  inherit (dune_3) src version;

  minimalOCamlVersion = "4.08";

  dontAddPrefix = true;

  propagatedBuildInputs = [ stdune ];

  preBuild = ''
    rm -r vendor/csexp
  '';

  meta = with lib; {
    description = "Private libraries of Dune";
    maintainers = [ ];
    license = licenses.mit;
  };
}
