{
  lib,
  buildDunePackage,
  dune_3,
}:

buildDunePackage {
  pname = "chrome-trace";
  inherit (dune_3) src version;

  minimalOCamlVersion = "4.08";
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
