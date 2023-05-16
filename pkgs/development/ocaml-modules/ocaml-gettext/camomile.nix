<<<<<<< HEAD
{ lib, buildDunePackage, ocaml, ocaml_gettext, camomile, ounit, fileutils }:
=======
{ buildDunePackage, ocaml_gettext, camomile, ounit, fileutils }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildDunePackage {
  pname = "gettext-camomile";
  inherit (ocaml_gettext) src version;

  propagatedBuildInputs = [ camomile ocaml_gettext ];

<<<<<<< HEAD
  doCheck = lib.versionAtLeast ocaml.version "4.08";
=======
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkInputs = [ ounit fileutils ];

  meta = (builtins.removeAttrs ocaml_gettext.meta [ "mainProgram" ]) // {
    description = "Internationalization library using camomile (i18n)";
  };

}
