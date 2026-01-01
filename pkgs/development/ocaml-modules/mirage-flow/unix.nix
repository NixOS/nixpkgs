{
  buildDunePackage,
  fmt,
  logs,
  mirage-flow,
<<<<<<< HEAD
  lwt,
=======
  ocaml_lwt,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cstruct,
  alcotest,
  mirage-flow-combinators,
}:

buildDunePackage {
  pname = "mirage-flow-unix";

  inherit (mirage-flow) version src;

<<<<<<< HEAD
=======
  duneVersion = "3";

  # Make tests compatible with alcotest 1.4.0
  postPatch = ''
    substituteInPlace test/test.ml --replace 'Fmt.kstrf Alcotest.fail' 'Fmt.kstrf (fun s -> Alcotest.fail s)'
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  propagatedBuildInputs = [
    fmt
    logs
    mirage-flow
<<<<<<< HEAD
    lwt
=======
    ocaml_lwt
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    cstruct
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mirage-flow-combinators
  ];

  meta = mirage-flow.meta // {
    description = "Flow implementations and combinators for MirageOS on Unix";
  };
}
