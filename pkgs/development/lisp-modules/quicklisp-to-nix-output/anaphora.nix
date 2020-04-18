args @ { fetchurl, ... }:
rec {
  baseName = ''anaphora'';
  version = ''20191007-git'';

  parasites = [ "anaphora/test" ];

  description = ''The Anaphoric Macro Package from Hell'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/anaphora/2019-10-07/anaphora-20191007-git.tgz'';
    sha256 = ''0iwfddh3cycjr9vhjnr1ldd5xc3qwqhrp41904s1dvysf99277kv'';
  };

  packageName = "anaphora";

  asdFilesToKeep = ["anaphora.asd"];
  overrides = x: x;
}
/* (SYSTEM anaphora DESCRIPTION The Anaphoric Macro Package from Hell SHA256
    0iwfddh3cycjr9vhjnr1ldd5xc3qwqhrp41904s1dvysf99277kv URL
    http://beta.quicklisp.org/archive/anaphora/2019-10-07/anaphora-20191007-git.tgz
    MD5 bfaae44cfb6226f35f0afde335e51ca4 NAME anaphora FILENAME anaphora DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20191007-git SIBLINGS NIL
    PARASITES (anaphora/test)) */
