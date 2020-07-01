{ lib, buildDunePackage, ocaml_gettext, ounit }:

buildDunePackage rec {

  pname = "gettext-stub";

  inherit (ocaml_gettext) src version meta;

  propagatedBuildInputs = [ ocaml_gettext ];

  doCheck = true;

  checkInputs = lib.optional doCheck ounit;
}
