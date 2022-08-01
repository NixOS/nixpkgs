{ lib, buildDunePackage
, git, irmin, irmin-test, ppx_irmin, git-unix
, digestif, cstruct, fmt, astring, fpath, logs, lwt, uri, mimic
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
    mimic
  ];

  checkInputs = [ mtime alcotest git-unix irmin-test cacert ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Git backend for Irmin";
  };

}

