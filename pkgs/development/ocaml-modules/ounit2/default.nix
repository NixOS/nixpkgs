{ lib, ocaml, buildDunePackage, fetchurl, stdlib-shims, ncurses }:

buildDunePackage rec {
  minimumOCamlVersion = "4.04";

  pname = "ounit2";
  version = "2.2.4";

  useDune2 = lib.versionAtLeast ocaml.version "4.08";

  src = fetchurl {
    url = "https://github.com/gildor478/ounit/releases/download/v${version}/ounit-v${version}.tbz";
    sha256 = "0i9kiqbf2dp12c4qcvbn4abdpdp6h4g5z54ycsh0q8jpv6jnkh5m";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  doCheck = true;
  checkInputs = lib.optional (lib.versionOlder ocaml.version "4.07") ncurses;

  meta = with lib; {
    homepage = "https://github.com/gildor478/ounit";
    description = "A unit test framework for OCaml";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
