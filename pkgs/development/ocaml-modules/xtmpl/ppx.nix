{ buildDunePackage, xtmpl, ppxlib }:

buildDunePackage {
  pname = "xtmpl_ppx";
  minimalOCamlVersion = "4.11";

  inherit (xtmpl) src version useDune2;

  buildInputs = [ ppxlib xtmpl ];

  meta = xtmpl.meta // {
    description = "Xml templating library, ppx extension";
  };
}
