{ lib, buildDunePackage
, git, irmin, irmin-test, ppx_irmin, git-cohttp-unix, git-unix
, digestif, cstruct, fmt, astring, fpath, logs, lwt, uri
, mtime, alcotest, cacert
}:

buildDunePackage {

  pname = "irmin-git";

  inherit (irmin) version src;

  useDune2 = true;

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
  ];

  checkInputs = [ mtime alcotest git-cohttp-unix git-unix irmin-test cacert ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Git backend for Irmin";
  };

}

