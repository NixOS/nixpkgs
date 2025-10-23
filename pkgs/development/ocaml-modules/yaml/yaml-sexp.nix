{
  buildDunePackage,
  yaml,
  ppx_sexp_conv,
  sexplib,
  junit_alcotest,
}:

buildDunePackage {
  pname = "yaml-sexp";

  inherit (yaml) version src;

  propagatedBuildInputs = [
    yaml
    ppx_sexp_conv
    sexplib
  ];

  doCheck = true;
  checkInputs = [ junit_alcotest ];

  meta = yaml.meta // {
    description = "ocaml-yaml with sexp support";
  };
}
