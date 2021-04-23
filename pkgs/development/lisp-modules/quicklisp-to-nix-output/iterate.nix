/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "iterate";
  version = "20210228-git";

  parasites = [ "iterate/tests" ];

  description = "Jonathan Amsterdam's iterator/gatherer/accumulator facility";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/iterate/2021-02-28/iterate-20210228-git.tgz";
    sha256 = "1bd6m1lxmd6an75z7j61sms4v54bfxmg1n1w7zd7fm2kb15vai46";
  };

  packageName = "iterate";

  asdFilesToKeep = ["iterate.asd"];
  overrides = x: x;
}
/* (SYSTEM iterate DESCRIPTION
    Jonathan Amsterdam's iterator/gatherer/accumulator facility SHA256
    1bd6m1lxmd6an75z7j61sms4v54bfxmg1n1w7zd7fm2kb15vai46 URL
    http://beta.quicklisp.org/archive/iterate/2021-02-28/iterate-20210228-git.tgz
    MD5 16a4d7811ffc0f4a1cc45257c4cefd1d NAME iterate FILENAME iterate DEPS NIL
    DEPENDENCIES NIL VERSION 20210228-git SIBLINGS NIL PARASITES
    (iterate/tests)) */
