{
  lib,
  buildDunePackage,
  dune_3,
  dyn,
}:

buildDunePackage {
  pname = "ocamlc-loc";
  inherit (dune_3) src version;
  duneVersion = "3";

  dontAddPrefix = true;

  preBuild = ''
    rm -rf vendor/csexp
    rm -rf vendor/pp
  '';

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ dyn ];

  meta = with lib; {
    description = "Parse ocaml compiler output into structured form";
    maintainers = [ maintainers.ulrikstrid ];
    license = licenses.mit;
  };
}
