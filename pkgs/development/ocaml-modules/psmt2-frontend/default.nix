{ lib, fetchFromGitHub, buildDunePackage, menhir }:

buildDunePackage rec {
  version = "0.3.1";
  pname = "psmt2-frontend";

  src = fetchFromGitHub {
    owner = "ACoquereau";
    repo = pname;
    rev = version;
    sha256 = "038jrfsq09nhnzpjiishg4adk09w3aw1bpczgbj66lqqilkd6gci";
  };

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  strictDeps = true;

  nativeBuildInputs = [ menhir ];

  meta = {
    description = "A simple parser and type-checker for polomorphic extension of the SMT-LIB 2 language";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };

}
