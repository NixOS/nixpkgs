<<<<<<< HEAD
{ lib, buildDunePackage, ocaml, ocaml_gettext, dune-configurator, ounit }:
=======
{ buildDunePackage, ocaml_gettext, dune-configurator, ounit }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildDunePackage rec {

  pname = "gettext-stub";

  inherit (ocaml_gettext) src version;

  minimalOCamlVersion = "4.06";

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [ ocaml_gettext ];

<<<<<<< HEAD
  doCheck = lib.versionAtLeast ocaml.version "4.08";
=======
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  checkInputs = [ ounit ];

  meta = builtins.removeAttrs ocaml_gettext.meta  [ "mainProgram" ];
}
