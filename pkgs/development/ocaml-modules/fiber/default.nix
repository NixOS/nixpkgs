{ lib, buildDunePackage, dune_3, stdune, dyn }:

buildDunePackage rec {
  pname = "fiber";
  inherit (dune_3) src version;

  duneVersion = "3";

  dontAddPrefix = true;

  buildInputs = [ stdune dyn ];

  preBuild = ''
    rm -r vendor/csexp
  '';

  meta = with lib; {
    description = "Structured concurrency library";
    inherit (dune_3.meta) homepage;
    maintainers = with lib.maintainers; [ ];
    license = licenses.mit;
  };
}
