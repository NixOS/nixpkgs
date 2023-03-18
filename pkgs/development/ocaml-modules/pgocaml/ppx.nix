{ buildDunePackage, pgocaml, ppx_optcomp }:

buildDunePackage {
  pname = "pgocaml_ppx";
  inherit (pgocaml) src version meta;

  duneVersion = "3";

  buildInputs = [ ppx_optcomp ];
  propagatedBuildInputs = [ pgocaml ];
}
