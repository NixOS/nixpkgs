{ buildDunePackage, xtmpl, ppxlib }:

buildDunePackage {
  pname = "xtmpl_ppx";
  minimalOCamlVersion = "4.11";
  duneVersion = "3";

  inherit (xtmpl) src version;

  buildInputs = [ ppxlib xtmpl ];

  meta = xtmpl.meta // {
    description = "Xml templating library, ppx extension";
  };
}
