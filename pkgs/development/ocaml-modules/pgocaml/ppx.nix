{ buildDunePackage, pgocaml, ppx_tools, ppx_tools_versioned, rresult }:

buildDunePackage {
  pname = "pgocaml_ppx";
  inherit (pgocaml) src version meta;

  propagatedBuildInputs = [ pgocaml ppx_tools ppx_tools_versioned rresult ];
}
