{
  buildDunePackage,
  pgocaml,
  ppx_optcomp,
}:

buildDunePackage {
  pname = "pgocaml_ppx";
  inherit (pgocaml) src version meta;

  buildInputs = [ ppx_optcomp ];
  propagatedBuildInputs = [ pgocaml ];
}
