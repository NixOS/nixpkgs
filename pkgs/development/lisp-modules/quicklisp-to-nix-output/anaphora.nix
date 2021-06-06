/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "anaphora";
  version = "20210124-git";

  parasites = [ "anaphora/test" ];

  description = "The Anaphoric Macro Package from Hell";

  deps = [ args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/anaphora/2021-01-24/anaphora-20210124-git.tgz";
    sha256 = "0b4xwrnv007sfcqkxkarrbf99v3md8h199z1z69r4vx7r5pq2i4v";
  };

  packageName = "anaphora";

  asdFilesToKeep = ["anaphora.asd"];
  overrides = x: x;
}
/* (SYSTEM anaphora DESCRIPTION The Anaphoric Macro Package from Hell SHA256
    0b4xwrnv007sfcqkxkarrbf99v3md8h199z1z69r4vx7r5pq2i4v URL
    http://beta.quicklisp.org/archive/anaphora/2021-01-24/anaphora-20210124-git.tgz
    MD5 09a11971206da9d259b34c050783b74b NAME anaphora FILENAME anaphora DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20210124-git SIBLINGS NIL
    PARASITES (anaphora/test)) */
