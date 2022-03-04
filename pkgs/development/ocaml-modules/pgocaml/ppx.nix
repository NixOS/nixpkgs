{ buildDunePackage, pgocaml, ppx_optcomp }:

buildDunePackage {
  pname = "pgocaml_ppx";
  inherit (pgocaml) src version meta;

  propagatedBuildInputs = [ pgocaml ppx_optcomp ];
}
