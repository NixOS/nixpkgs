{
  buildDunePackage,
<<<<<<< HEAD
  dune,
=======
  dune_3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  dyn,
  ordering,
  csexp,
}:

buildDunePackage {
  pname = "stdune";
<<<<<<< HEAD
  inherit (dune) version src;
=======
  inherit (dune_3) version src;
  duneVersion = "3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dontAddPrefix = true;

  propagatedBuildInputs = [
    dyn
    ordering
    csexp
  ];

  preBuild = ''
    rm -r vendor/csexp
  '';

<<<<<<< HEAD
  meta = dune.meta // {
=======
  meta = dune_3.meta // {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Dune's unstable standard library";
  };
}
