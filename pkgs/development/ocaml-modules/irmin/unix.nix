{ lib, buildDunePackage
, checkseum, cmdliner, git-unix, yaml
, irmin, irmin-fs, irmin-git, irmin-graphql, irmin-http, irmin-mem, irmin-pack, irmin-watcher
, irmin-test
}:

buildDunePackage rec {

  pname = "irmin-unix";

  inherit (irmin) version src;

  propagatedBuildInputs = [ checkseum cmdliner git-unix yaml
    irmin irmin-fs irmin-git irmin-graphql irmin-http irmin-mem irmin-pack irmin-watcher
  ];

  checkInputs = lib.optional doCheck irmin-test;

  doCheck = true;

  meta = irmin.meta // {
    description = "Unix backends for Irmin";
  };

}

