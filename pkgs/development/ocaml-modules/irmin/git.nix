{ lib, buildDunePackage
, git, irmin, irmin-test, ppx_irmin, git-unix
, digestif, cstruct, fmt, astring, fpath, logs, lwt, uri
, mtime, alcotest, cacert
}:

buildDunePackage rec {

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
  ];

  buildInputs = checkInputs; # dune builds tests at build-time
  checkInputs = [ mtime alcotest git-unix irmin-test cacert ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Git backend for Irmin";
  };

}

