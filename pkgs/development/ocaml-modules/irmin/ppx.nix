{ lib, buildDunePackage, ppxlib, ocaml-syntax-shims, irmin }:

buildDunePackage {
  pname = "ppx_irmin";

  inherit (irmin) version src minimumOCamlVersion;

  useDune2 = true;

  buildInputs = [ ocaml-syntax-shims ];
  propagatedBuildInputs = [ ppxlib ];

  meta = irmin.meta // {
    description = "PPX deriver for Irmin generics";
  };
}
