{ lib, ocaml, buildDunePackage, fetchurl, seq, stdlib-shims, ncurses }:

buildDunePackage rec {
  minimumOCamlVersion = "4.04";

  pname = "ounit2";
  version = "2.2.6";

  useDune2 = lib.versionAtLeast ocaml.version "4.08";

  src = fetchurl {
    url = "https://github.com/gildor478/ounit/releases/download/v${version}/ounit-${version}.tbz";
    sha256 = "sha256-BpD7Hg6QoY7tXDVms8wYJdmLDox9UbtrhGyVxFphWRM=";
  };

  propagatedBuildInputs = [ seq stdlib-shims ];

  doCheck = true;
  nativeCheckInputs = lib.optional (lib.versionOlder ocaml.version "4.07") ncurses;

  meta = with lib; {
    homepage = "https://github.com/gildor478/ounit";
    description = "A unit test framework for OCaml";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
