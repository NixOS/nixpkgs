{
  buildDunePackage,
  eio,
  linol,
<<<<<<< HEAD
=======
  yojson,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildDunePackage {
  pname = "linol-eio";
  inherit (linol) version src;

  propagatedBuildInputs = [
    eio
    linol
<<<<<<< HEAD
=======
    yojson
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  meta = linol.meta // {
    description = "LSP server library (with Eio for concurrency)";
  };
}
