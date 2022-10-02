{ lib, buildDunePackage, dune_3 }:

buildDunePackage rec {
  pname = "chrome-trace";
  inherit (dune_3) src version;

  duneVersion = "3";

  dontAddPrefix = true;

  preBuild = ''
    rm -r vendor/csexp
  '';

  meta = with lib; {
    description = "Chrome trace event generation library";
    inherit (dune_3.meta) homepage;
    license = licenses.mit;
  };
}
