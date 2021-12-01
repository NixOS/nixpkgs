{ buildDunePackage, ocaml_gettext, camomile, ounit, fileutils }:

buildDunePackage {
  pname = "gettext-camomile";
  inherit (ocaml_gettext) src version useDune2;

  propagatedBuildInputs = [ camomile ocaml_gettext ];

  doCheck = true;
  checkInputs = [ ounit fileutils ];

  meta = ocaml_gettext.meta // {
    description = "Internationalization library using camomile (i18n)";
  };

}
