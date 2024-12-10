{
  lib,
  buildDunePackage,
  github,
  cohttp,
  cohttp-lwt-unix,
  stringext,
  cmdliner,
  lwt,
}:

buildDunePackage {
  pname = "github-unix";
  inherit (github) version src;

  postPatch = ''
    substituteInPlace unix/dune --replace 'github bytes' 'github'
  '';

  propagatedBuildInputs = [
    github
    cohttp
    cohttp-lwt-unix
    stringext
    cmdliner
    lwt
  ];

  meta = github.meta // {
    description = "GitHub APIv3 Unix library";
  };
}
