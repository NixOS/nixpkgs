{
  buildDunePackage,
  mirage-flow,
  lwt,
  logs,
  cstruct,
<<<<<<< HEAD
  mirage-mtime,
=======
  mirage-clock,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildDunePackage {
  pname = "mirage-flow-combinators";

  inherit (mirage-flow) version src;

<<<<<<< HEAD
=======
  duneVersion = "3";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  propagatedBuildInputs = [
    lwt
    logs
    cstruct
<<<<<<< HEAD
    mirage-mtime
=======
    mirage-clock
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mirage-flow
  ];

  meta = mirage-flow.meta // {
    description = "Flow implementations and combinators for MirageOS specialized to lwt";
  };
}
