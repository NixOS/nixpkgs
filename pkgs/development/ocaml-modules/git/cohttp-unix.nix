{ buildDunePackage, git, git-cohttp
, cohttp-lwt-unix, cohttp-lwt, fmt, lwt, result, rresult, uri
}:

buildDunePackage {
  pname = "git-cohttp-unix";

  inherit (git) version src minimumOCamlVersion useDune2;

  propagatedBuildInputs = [
    git git-cohttp cohttp-lwt-unix cohttp-lwt fmt lwt result rresult uri
  ];

  meta = git.meta // {
    description = "A package to use HTTP-based ocaml-git with Unix backend";
  };
}
