{ fetchFromGitHub, buildDunePackage, ocaml_pcre, mparser }:

buildDunePackage rec {
  pname = "mparser-pcre";
  useDune2 = true;

  inherit (mparser) src version;

  buildInputs = [ ocaml_pcre mparser ];

  meta = mparser.meta // { description = "PCRE-based regular expressions"; };
}
