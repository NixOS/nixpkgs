{ stdenv, fetchFromGitHub, buildDunePackage, angstrom }:

buildDunePackage rec {
  pname = "angstrom-unix";

  inherit (angstrom) version src;

  minimumOCamlVersion = "4.03";

  propagatedBuildInputs = [ angstrom ];

  doCheck = true;

  meta = {
    inherit (angstrom.meta) homepage license;
    description = "Unix support for Angstrom";
    maintainers = with stdenv.lib.maintainers; [ romildo ];
  };
}
