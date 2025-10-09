{
  buildDunePackage,
  xtmpl,
  ppxlib,
}:

buildDunePackage {
  pname = "xtmpl_ppx";

  inherit (xtmpl) src version;

  buildInputs = [
    ppxlib
    xtmpl
  ];

  meta = xtmpl.meta // {
    description = "Xml templating library, ppx extension";
  };
}
