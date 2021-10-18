{ lib, fetchurl, buildDunePackage, yaml, dune-configurator, ppx_sexp_conv, sexplib }:

buildDunePackage rec {
  pname = "yaml-sexp";
  version = "3.0.0";

  useDune2 = true;

  src = fetchurl {
    url =
      "https://github.com/avsm/ocaml-yaml/releases/download/v${version}/yaml-v${version}.tbz";
    sha256 = "1iws6lbnrrd5hhmm7lczfvqp0aidx5xn7jlqk2s5rjfmj9qf4j2c";
  };

  propagatedBuildInputs = [ yaml ppx_sexp_conv sexplib ];

  meta = {
    description = "ocaml-yaml with sexp support";
    homepage = "https://github.com/avsm/ocaml-yaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
