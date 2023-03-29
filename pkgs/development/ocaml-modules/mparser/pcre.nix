{ fetchFromGitHub, buildDunePackage, ocaml_pcre, mparser }:

buildDunePackage rec {
  pname = "mparser-pcre";

  inherit (mparser) src version;

  duneVersion = "3";

  propagatedBuildInputs = [ ocaml_pcre mparser ];

  meta = mparser.meta // { description = "PCRE-based regular expressions"; };
}
