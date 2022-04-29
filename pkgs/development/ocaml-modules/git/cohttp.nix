{ buildDunePackage, git
, cohttp, cohttp-lwt, fmt, lwt, result, rresult, uri
, alcotest, alcotest-lwt, bigstringaf, cstruct, logs
, mirage-flow, ke
}:

buildDunePackage rec {
  pname = "git-cohttp";

  inherit (git) version minimumOCamlVersion src useDune2;

  propagatedBuildInputs = [
    git cohttp cohttp-lwt fmt lwt result rresult uri
  ];

  meta = git.meta // {
    description = "A package to use HTTP-based ocaml-git with Unix backend";
  };
}
