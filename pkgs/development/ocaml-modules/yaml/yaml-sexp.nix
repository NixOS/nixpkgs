{ lib, fetchurl, buildDunePackage, yaml, dune-configurator, ppx_sexp_conv, sexplib }:

buildDunePackage rec {
  pname = "yaml-sexp";

  inherit (yaml) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ yaml ppx_sexp_conv sexplib ];

  meta = yaml.meta // {
    description = "ocaml-yaml with sexp support";
  };
}
