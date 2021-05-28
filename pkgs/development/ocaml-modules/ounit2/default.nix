{ lib, buildDunePackage, fetchurl, stdlib-shims }:

buildDunePackage rec {
  minimumOCamlVersion = "4.04";

  pname = "ounit2";
  version = "2.2.3";

  src = fetchurl {
    url = "https://github.com/gildor478/ounit/releases/download/v${version}/ounit-v${version}.tbz";
    sha256 = "1naahh24lbyxmrnzpfz8karniqbf1nknivf96mrvsr6zlx5ad072";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  meta = with lib; {
    homepage = "https://github.com/gildor478/ounit";
    description = "A unit test framework for OCaml";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
