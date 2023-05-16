<<<<<<< HEAD
{ lib, fetchurl, buildDunePackage, ocaml, stdlib-shims, ounit2 }:
=======
{ lib, fetchurl, buildDunePackage, stdlib-shims, ounit2 }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildDunePackage rec {
  pname = "sha";
  version = "1.15.4";
<<<<<<< HEAD
=======
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    url = "https://github.com/djs55/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-beWxITmxmZzp30zHiloxiGwqVHydRIvyhT+LU7zx8bE=";
  };

  propagatedBuildInputs = [
    stdlib-shims
  ];

<<<<<<< HEAD
  doCheck = lib.versionAtLeast ocaml.version "4.08";
=======
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkInputs = [
    ounit2
  ];

  meta = with lib; {
    description = "Binding for SHA interface code in OCaml";
    homepage = "https://github.com/djs55/ocaml-sha/";
    license = licenses.isc;
    maintainers = with maintainers; [ arthurteisseire ];
  };
}
