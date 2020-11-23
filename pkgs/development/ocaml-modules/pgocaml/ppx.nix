{ buildDunePackage, pgocaml, ppx_optcomp, ppx_tools, ppx_tools_versioned, rresult }:

buildDunePackage {
  pname = "pgocaml_ppx";
  inherit (pgocaml) src version useDune2 meta;

  propagatedBuildInputs = [ pgocaml ppx_optcomp ppx_tools ppx_tools_versioned rresult ];
}
