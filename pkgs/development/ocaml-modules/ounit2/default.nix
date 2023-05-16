{ lib, ocaml, buildDunePackage, fetchurl, seq, stdlib-shims, ncurses }:

<<<<<<< HEAD
buildDunePackage rec {
  minimalOCamlVersion = "4.08";

  pname = "ounit2";
  version = "2.2.7";

  src = fetchurl {
    url = "https://github.com/gildor478/ounit/releases/download/v${version}/ounit-${version}.tbz";
    hash = "sha256-kPbmO9EkClHYubL3IgWb15zgC1J2vdYji49cYTwOc4g=";
=======
buildDunePackage (rec {
  minimalOCamlVersion = "4.04";

  pname = "ounit2";
  version = "2.2.6";

  src = fetchurl {
    url = "https://github.com/gildor478/ounit/releases/download/v${version}/ounit-${version}.tbz";
    hash = "sha256-BpD7Hg6QoY7tXDVms8wYJdmLDox9UbtrhGyVxFphWRM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ seq stdlib-shims ];

  doCheck = true;
<<<<<<< HEAD
=======
  checkInputs = lib.optional (lib.versionOlder ocaml.version "4.07") ncurses;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/gildor478/ounit";
    description = "A unit test framework for OCaml";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
<<<<<<< HEAD
}
=======
} // lib.optionalAttrs (!lib.versionAtLeast ocaml.version "4.08") {
  duneVersion = "1";
})
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
