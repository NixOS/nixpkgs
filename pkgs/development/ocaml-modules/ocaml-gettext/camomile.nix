{
  lib,
  buildDunePackage,
  ocaml_gettext,
  camomile,
  ounit2,
}:

buildDunePackage {
  pname = "gettext-camomile";
  inherit (ocaml_gettext) src version;

  propagatedBuildInputs = [
    camomile
    ocaml_gettext
  ];

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = (removeAttrs ocaml_gettext.meta [ "mainProgram" ]) // {
    description = "Internationalization library using camomile (i18n)";
  };

}
