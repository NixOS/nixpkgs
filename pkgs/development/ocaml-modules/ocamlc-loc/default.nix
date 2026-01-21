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

  preBuild = ''
    rm -rf vendor/csexp
    rm -rf vendor/pp
  '';

  propagatedBuildInputs = [ dyn ];

  meta = {
    description = "Parse ocaml compiler output into structured form";
    maintainers = [ lib.maintainers.ulrikstrid ];
    license = lib.licenses.mit;
  };
}
