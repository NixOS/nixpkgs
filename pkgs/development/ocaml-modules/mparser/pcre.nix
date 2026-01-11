{
  buildDunePackage,
  ocaml_pcre,
  mparser,
}:

buildDunePackage {
  pname = "mparser-pcre";

  inherit (mparser) src version;

  propagatedBuildInputs = [
    ocaml_pcre
    mparser
  ];

  meta = mparser.meta // {
    description = "PCRE-based regular expressions";
  };
}
