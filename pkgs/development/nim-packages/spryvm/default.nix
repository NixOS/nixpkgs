{ lib, buildNimPackage, fetchFromGitHub, sqlite }:

buildNimPackage rec {
  pname = "spryvm";
  version = "0.9.3";
  src = fetchFromGitHub {
    owner = "gokr";
    repo = pname;
    rev = "36c2b56bb194902d33de7bcf70d3041703e107ab";
    hash = "sha256-OxB49ef6qPvSXLsyVl5g2ic/P9MMbF3jRYDWrxNJ0Iw=";
  };
  propagatedBuildInputs = [ sqlite ];
  patches = [ ./nil.patch ];
  meta = with lib;
    src.meta // {
      description = "Spry virtual machine";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
