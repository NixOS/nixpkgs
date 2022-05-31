{ lib, buildDunePackage, cohttp-lwt, irmin, webmachine
, checkseum, git-unix, irmin-git, irmin-test, digestif
, cacert
}:

buildDunePackage rec {

  pname = "irmin-http";

  inherit (irmin) version src strictDeps;

  propagatedBuildInputs = [ cohttp-lwt irmin webmachine ];

  buildInputs = checkInputs; # dune builds tests at build-time
  checkInputs = [
    digestif checkseum git-unix irmin-git irmin-test cacert
  ];

  doCheck = true;

  meta = irmin.meta // {
    description = "HTTP client and server for Irmin";
  };

}


