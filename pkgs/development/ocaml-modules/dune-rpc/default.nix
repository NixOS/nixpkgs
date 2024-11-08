{ lib, buildDunePackage, dune_3, csexp, stdune, ordering, pp, xdg, dyn }:

buildDunePackage rec {
  pname = "dune-rpc";
  inherit (dune_3) src version;

  duneVersion = "3";

  dontAddPrefix = true;

  propagatedBuildInputs = [ csexp stdune ordering pp xdg dyn ];

  preBuild = ''
    rm -r vendor/csexp
  '';

  meta = with lib; {
    description = "Library to connect and control a running dune instance";
    inherit (dune_3.meta) homepage;
    maintainers = [ ];
    license = licenses.mit;
  };
}
