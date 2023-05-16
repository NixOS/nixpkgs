{ lib, fetchurl, buildDunePackage
, containers
, oseq
<<<<<<< HEAD
, alcotest
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildDunePackage rec {
  pname = "dscheck";
<<<<<<< HEAD
  version = "0.2.0";

  minimalOCamlVersion = "5.0";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/dscheck/releases/download/${version}/dscheck-${version}.tbz";
    hash = "sha256-QgkbnD3B1lONg9U60BM2xWVgIt6pZNmOmxkKy+UJH9E=";
=======
  version = "0.1.0";

  minimalOCamlVersion = "5.0";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/dscheck/releases/download/${version}/dscheck-${version}.tbz";
    hash = "sha256-zoouFZJcUp71yeluVb1xLUIMcFv99OpkcQQCHkPTKcI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ containers oseq ];

  doCheck = true;
<<<<<<< HEAD
  checkInputs = [ alcotest ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "Traced atomics";
    homepage = "https://github.com/ocaml-multicore/dscheck";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
