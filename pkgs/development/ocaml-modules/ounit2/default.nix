{ lib, buildDunePackage, fetchurl, seq, stdlib-shims }:

buildDunePackage rec {
  minimalOCamlVersion = "4.08";

  pname = "ounit2";
  version = "2.2.7";

  src = fetchurl {
    url = "https://github.com/gildor478/ounit/releases/download/v${version}/ounit-${version}.tbz";
    hash = "sha256-kPbmO9EkClHYubL3IgWb15zgC1J2vdYji49cYTwOc4g=";
  };

  propagatedBuildInputs = [ seq stdlib-shims ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/gildor478/ounit";
    description = "Unit test framework for OCaml";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
