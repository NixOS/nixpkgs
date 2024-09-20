{ lib, buildDunePackage, dune_3, dune-private-libs }:

buildDunePackage rec {
  pname = "dune-glob";
  inherit (dune_3) src version;

  duneVersion = "3";

  dontAddPrefix = true;

  propagatedBuildInputs = [ dune-private-libs ];

  preBuild = ''
    rm -r vendor/csexp
  '';

  meta = with lib; {
    inherit (dune_3.meta) homepage;
    description = "Glob string matching language supported by dune";
    maintainers = [ ];
    license = licenses.mit;
  };
}
