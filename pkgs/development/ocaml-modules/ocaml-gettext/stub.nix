{
  lib,
  buildDunePackage,
  ocaml_gettext,
  dune-configurator,
  ounit2,
}:

buildDunePackage {
  pname = "gettext-stub";
  inherit (ocaml_gettext) src version;

  minimalOCamlVersion = "4.14";

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ocaml_gettext ];

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = removeAttrs ocaml_gettext.meta [ "mainProgram" ];
}
