{
  lib,
  buildDunePackage,
  github,
  cohttp,
  cohttp-lwt-jsoo,
  js_of_ocaml-lwt,
}:

buildDunePackage {
  pname = "github-jsoo";
  inherit (github) version src;

  duneVersion = "3";

  propagatedBuildInputs = [
    github
    cohttp
    cohttp-lwt-jsoo
    js_of_ocaml-lwt
  ];

  meta = github.meta // {
    description = "GitHub APIv3 JavaScript library";
  };
}
