{
  lib,
  buildDunePackage,
  ocaml,
  ocaml_gettext,
  camomile,
  ounit,
  fileutils,
}:

buildDunePackage {
  pname = "gettext-camomile";
  inherit (ocaml_gettext) src version;

  propagatedBuildInputs = [
    (camomile.override { version = "1.0.2"; })
    ocaml_gettext
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [
    ounit
    fileutils
  ];

  meta = (builtins.removeAttrs ocaml_gettext.meta [ "mainProgram" ]) // {
    description = "Internationalization library using camomile (i18n)";
  };

}
