{ lib, buildDunePackage, astring, cohttp-lwt, cohttp-lwt-unix, irmin, webmachine
, fmt, jsonm, logs, lwt, uri
, git-unix, irmin-git, irmin-test, irmin-fs, digestif
, cacert
}:

buildDunePackage rec {

  pname = "irmin-http";

  inherit (irmin) version src strictDeps;

  propagatedBuildInputs = [ astring cohttp-lwt cohttp-lwt-unix fmt jsonm logs lwt uri irmin webmachine ];

  checkInputs = [
    digestif git-unix irmin-git irmin-test irmin-fs cacert
  ];

  doCheck = true;

  meta = irmin.meta // {
    description = "HTTP client and server for Irmin";
  };

}
