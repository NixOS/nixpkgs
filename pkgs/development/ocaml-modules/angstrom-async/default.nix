{ lib, fetchFromGitHub, buildDunePackage, angstrom, async }:

buildDunePackage rec {
  pname = "angstrom-async";

  inherit (angstrom) version src;

  duneVersion = "3";
  minimalOCamlVersion = "4.04.1";

  propagatedBuildInputs = [ angstrom async ];

  doCheck = true;

  meta = {
    inherit (angstrom.meta) homepage license;
    description = "Async support for Angstrom";
    maintainers = with lib.maintainers; [ romildo ];
  };
}
