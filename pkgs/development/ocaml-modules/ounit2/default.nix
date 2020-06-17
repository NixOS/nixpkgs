{ lib, buildDunePackage, fetchurl, stdlib-shims }:

buildDunePackage rec {
  minimumOCamlVersion = "4.02.3";

  pname = "ounit2";
  version = "2.2.2";

  src = fetchurl {
    url = "https://github.com/gildor478/ounit/releases/download/v${version}/ounit-v${version}.tbz";
    sha256 = "1h4xdcyzwyhxg263w9b16x9n6cb11fzazmwnsnpich4djpl9lhsk";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  meta = with lib; {
    homepage = "https://github.com/gildor478/ounit";
    description = "A unit test framework for OCaml";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
