/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "iterate";
  version = "release-b0f9a9c6-git";

  parasites = [ "iterate/tests" ];

  description = "Jonathan Amsterdam's iterator/gatherer/accumulator facility";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/iterate/2021-05-31/iterate-release-b0f9a9c6-git.tgz";
    sha256 = "1fqk0iaqg7xjwhdr8q05birlpwh4zvmlranmsmfps3wmldccc4ck";
  };

  packageName = "iterate";

  asdFilesToKeep = ["iterate.asd"];
  overrides = x: x;
}
/* (SYSTEM iterate DESCRIPTION
    Jonathan Amsterdam's iterator/gatherer/accumulator facility SHA256
    1fqk0iaqg7xjwhdr8q05birlpwh4zvmlranmsmfps3wmldccc4ck URL
    http://beta.quicklisp.org/archive/iterate/2021-05-31/iterate-release-b0f9a9c6-git.tgz
    MD5 0b2661e9b8195f3e5891aa14601e5a69 NAME iterate FILENAME iterate DEPS NIL
    DEPENDENCIES NIL VERSION release-b0f9a9c6-git SIBLINGS NIL PARASITES
    (iterate/tests)) */
