{ lib, buildDunePackage
, git, mimic, cohttp-mirage, cohttp, cohttp-lwt
, fmt, lwt, result, rresult, uri
}:

buildDunePackage {
  pname = "git-cohttp-mirage";

  inherit (git) version src minimumOCamlVersion useDune2;

  propagatedBuildInputs = [
    git mimic cohttp-mirage cohttp cohttp-lwt fmt lwt result rresult uri
  ];

  meta = git.meta // {
    description = "A package to use HTTP-based ocaml-git with MirageOS backend";
  };
}
