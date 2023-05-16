{ lib, fetchurl, buildDunePackage, ocaml
, astring
, ounit
}:

buildDunePackage rec {
  pname = "parse-argv";
  version = "0.2.0";

<<<<<<< HEAD
  minimalOCamlVersion = "4.03";
=======
  useDune2 = true;

  minimumOCamlVersion = "4.03";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    url = "https://github.com/mirage/parse-argv/releases/download/v${version}/parse-argv-v${version}.tbz";
    sha256 = "06dl04fcmwpkydzni2fzwrhk0bqypd55mgxfax9v82x65xrgj5gw";
  };

  propagatedBuildInputs = [ astring ];

<<<<<<< HEAD
  doCheck = lib.versionAtLeast ocaml.version "4.08";
=======
  doCheck = lib.versionAtLeast ocaml.version "4.04";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkInputs = [ ounit ];

  meta = {
    description = "Process strings into sets of command-line arguments";
    homepage = "https://github.com/mirage/parse-argv";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
