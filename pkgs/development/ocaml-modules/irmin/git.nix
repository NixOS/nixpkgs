{ lib, buildDunePackage
, git, irmin, ppx_irmin, git-unix, irmin-watcher
, digestif, cstruct, fmt, astring, fpath, logs, lwt, uri
, cohttp-lwt-unix, mimic
, irmin-test, mtime, alcotest, cacert
}:

buildDunePackage {

  pname = "irmin-git";

  inherit (irmin) version src strictDeps;

  propagatedBuildInputs = [
    git
    irmin
    ppx_irmin
    digestif
    cstruct
    fmt
    astring
    fpath
    logs
    lwt
    uri
    irmin-watcher
    git-unix
    mimic
    cohttp-lwt-unix
  ];

  checkInputs = [ mtime alcotest irmin-test cacert ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Git backend for Irmin";
  };

}

