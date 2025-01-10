{
  lib,
  buildDunePackage,
  ocaml,
  ocaml_gettext,
  dune-configurator,
  ounit,
}:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "gettext-stub is not available for OCaml ${ocaml.version}"

  buildDunePackage
  {

    pname = "gettext-stub";

    inherit (ocaml_gettext) src version;

    minimalOCamlVersion = "4.06";

    buildInputs = [ dune-configurator ];

    propagatedBuildInputs = [ ocaml_gettext ];

    doCheck = lib.versionAtLeast ocaml.version "4.08";

    checkInputs = [ ounit ];

    meta = builtins.removeAttrs ocaml_gettext.meta [ "mainProgram" ];
  }
