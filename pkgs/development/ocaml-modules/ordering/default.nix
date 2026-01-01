<<<<<<< HEAD
{ buildDunePackage, dune }:

buildDunePackage {
  pname = "ordering";
  inherit (dune) version src;

  dontAddPrefix = true;

  meta = dune.meta // {
=======
{ buildDunePackage, dune_3 }:

buildDunePackage {
  pname = "ordering";
  inherit (dune_3) version src;
  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  dontAddPrefix = true;

  meta = dune_3.meta // {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Element ordering";
  };
}
