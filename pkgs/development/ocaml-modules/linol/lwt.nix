{
  buildDunePackage,
  linol,
  lwt,
<<<<<<< HEAD
=======
  yojson,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildDunePackage {
  pname = "linol-lwt";
  inherit (linol) version src;

  propagatedBuildInputs = [
    linol
    lwt
<<<<<<< HEAD
=======
    yojson
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  meta = linol.meta // {
    description = "LSP server library (with Lwt for concurrency)";
  };
}
