<<<<<<< HEAD
{ lib, fetchurl, buildDunePackage, ocaml
=======
{ lib, fetchurl, buildDunePackage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ppx_sexp_conv, ounit2
}:

buildDunePackage rec {
  pname = "macaddr";
  version = "5.4.0";

  minimalOCamlVersion = "4.04";
<<<<<<< HEAD
=======
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/releases/download/v${version}/ipaddr-${version}.tbz";
    hash = "sha256-WmYpG/cQtF9+lVDs1WIievUZ1f7+iZ2hufsdD1HHNeo=";
  };

  checkInputs = [ ppx_sexp_conv ounit2 ];
<<<<<<< HEAD
  doCheck = lib.versionAtLeast ocaml.version "4.08";
=======
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/mirage/ocaml-ipaddr";
    description = "A library for manipulation of MAC address representations";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
