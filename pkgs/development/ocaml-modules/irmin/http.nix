{ lib, buildDunePackage, cohttp-lwt, irmin, webmachine
, checkseum, git-unix, irmin-git, irmin-test, digestif, git-cohttp-unix
, cacert
}:

buildDunePackage rec {

  pname = "irmin-http";

  inherit (irmin) version src;

  useDune2 = true;

  propagatedBuildInputs = [ cohttp-lwt irmin webmachine ];

  checkInputs = [
    digestif checkseum git-cohttp-unix git-unix irmin-git irmin-test cacert
  ];

  doCheck = true;

  meta = irmin.meta // {
    description = "HTTP client and server for Irmin";
  };

}


