{ lib, buildDunePackage, ocaml, ocaml_gettext, camomile_1, ounit, fileutils }:

buildDunePackage {
  pname = "gettext-camomile";
  inherit (ocaml_gettext) src version;

  propagatedBuildInputs = [ camomile_1 ocaml_gettext ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit fileutils ];

  meta = (builtins.removeAttrs ocaml_gettext.meta [ "mainProgram" ]) // {
    description = "Internationalization library using camomile (i18n)";
  };

}
