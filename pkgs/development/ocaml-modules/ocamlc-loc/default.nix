{
  lib,
  buildDunePackage,
<<<<<<< HEAD
  dune,
=======
  dune_3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  dyn,
}:

buildDunePackage {
  pname = "ocamlc-loc";
<<<<<<< HEAD
  inherit (dune) src version;
=======
  inherit (dune_3) src version;
  duneVersion = "3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dontAddPrefix = true;

  preBuild = ''
    rm -rf vendor/csexp
    rm -rf vendor/pp
  '';

<<<<<<< HEAD
  propagatedBuildInputs = [ dyn ];

  meta = {
    description = "Parse ocaml compiler output into structured form";
    maintainers = [ lib.maintainers.ulrikstrid ];
    license = lib.licenses.mit;
=======
  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ dyn ];

  meta = with lib; {
    description = "Parse ocaml compiler output into structured form";
    maintainers = [ maintainers.ulrikstrid ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
