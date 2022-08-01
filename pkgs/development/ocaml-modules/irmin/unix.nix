{ lib, buildDunePackage
, checkseum, cmdliner_1_1, git-unix, yaml, fpath
, irmin, irmin-fs, irmin-git, irmin-graphql, irmin-http
, irmin-pack, irmin-watcher, irmin-test, cacert, irmin-tezos
, conduit-lwt-unix, cohttp-lwt-unix, mdx
}:

buildDunePackage rec {

  pname = "irmin-unix";

  inherit (irmin) version src;

  useDune2 = true;

  propagatedBuildInputs = [
    checkseum cmdliner_1_1 git-unix yaml fpath
    irmin irmin-fs irmin-git irmin-graphql irmin-http
    irmin-pack irmin-watcher irmin-tezos conduit-lwt-unix
    cohttp-lwt-unix mdx
  ];

  checkInputs = [
    irmin-test cacert
  ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Unix backends for Irmin";
    mainProgram = "irmin";
  };

}

