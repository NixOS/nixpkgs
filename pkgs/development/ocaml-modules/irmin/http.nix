{ lib, buildDunePackage, cohttp-lwt, irmin, webmachine
, checkseum, git-unix, irmin-git, irmin-mem, irmin-test
}:

buildDunePackage rec {

  pname = "irmin-http";

  inherit (irmin) version src;

  propagatedBuildInputs = [ cohttp-lwt irmin webmachine ];

  checkInputs = lib.optionals doCheck [ checkseum git-unix irmin-git irmin-mem irmin-test ];

  doCheck = true;

  meta = irmin.meta // {
    description = "HTTP client and server for Irmin";
  };

}


