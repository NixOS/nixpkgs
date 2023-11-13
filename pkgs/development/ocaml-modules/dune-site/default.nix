{ lib, buildDunePackage, dune_3, dune-private-libs }:

buildDunePackage rec {
  pname = "dune-site";
  inherit (dune_3) src version;

  duneVersion = "3";

  dontAddPrefix = true;

  propagatedBuildInputs = [ dune-private-libs ];

  preBuild = ''
    rm -r vendor/csexp
  '';

  meta = with lib; {
    description = "A library for embedding location information inside executable and libraries";
    inherit (dune_3.meta) homepage;
    maintainers = with lib.maintainers; [ ];
    license = licenses.mit;
  };
}
