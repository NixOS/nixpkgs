{ lib, buildDunePackage
, checkseum, cmdliner, git-unix, yaml, fpath
, irmin, irmin-fs, irmin-git, irmin-graphql, irmin-http
, irmin-pack, irmin-watcher, irmin-test, irmin-tezos, cacert
, mdx
}:

buildDunePackage rec {
  pname = "irmin-unix";

  inherit (irmin) version src;

  nativeBuildInputs = [ mdx ];

  propagatedBuildInputs = [
    checkseum cmdliner git-unix yaml fpath
    irmin irmin-fs irmin-git irmin-graphql irmin-http
    irmin-pack irmin-watcher irmin-tezos
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

