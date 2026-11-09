{
  lib,
  buildDunePackage,
  dune,
  dyn,
}:

buildDunePackage {
  pname = "ocamlc-loc";
  inherit (dune) src version;

  dontAddPrefix = true;

  propagatedBuildInputs = [ dyn ];

  meta = {
    description = "Parse ocaml compiler output into structured form";
    maintainers = [ lib.maintainers.ulrikstrid ];
    license = lib.licenses.mit;
  };
}
