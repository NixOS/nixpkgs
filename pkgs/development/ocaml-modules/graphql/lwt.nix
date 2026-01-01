{
  buildDunePackage,
  alcotest,
  graphql,
<<<<<<< HEAD
  lwt,
=======
  ocaml_lwt,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildDunePackage {
  pname = "graphql-lwt";

  inherit (graphql) version src;

<<<<<<< HEAD
  propagatedBuildInputs = [
    graphql
    lwt
=======
  duneVersion = "3";

  propagatedBuildInputs = [
    graphql
    ocaml_lwt
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = graphql.meta // {
    description = "Build GraphQL schemas with Lwt support";
  };

}
