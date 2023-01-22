{ lib, fetchFromGitHub, buildDunePackage, qcheck-alcotest }:

buildDunePackage rec {
  pname = "yuujinchou";
  version = "2.0.0";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "RedPRL";
    repo = pname;
    rev = version;
    sha256 = "sha256:1nhz44cyipy922anzml856532m73nn0g7iwkg79yzhq6yb87109w";
  };

  doCheck = true;
  nativeCheckInputs = [ qcheck-alcotest ];

  meta = {
    description = "Name pattern combinators";
    inherit (src.meta) homepage;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}

