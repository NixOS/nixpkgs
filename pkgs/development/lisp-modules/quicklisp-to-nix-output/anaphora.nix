args @ { fetchurl, ... }:
rec {
  baseName = ''anaphora'';
  version = ''20170227-git'';

  parasites = [ "anaphora/test" ];

  description = ''The Anaphoric Macro Package from Hell'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/anaphora/2017-02-27/anaphora-20170227-git.tgz'';
    sha256 = ''1inv6bcly6r7yixj1pp0i4h0y7lxyv68mk9wsi5iwi9gx6000yd9'';
  };

  packageName = "anaphora";

  asdFilesToKeep = ["anaphora.asd"];
  overrides = x: x;
}
/* (SYSTEM anaphora DESCRIPTION The Anaphoric Macro Package from Hell SHA256
    1inv6bcly6r7yixj1pp0i4h0y7lxyv68mk9wsi5iwi9gx6000yd9 URL
    http://beta.quicklisp.org/archive/anaphora/2017-02-27/anaphora-20170227-git.tgz
    MD5 6121d9bbc92df29d823b60ae0d0c556d NAME anaphora FILENAME anaphora DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20170227-git SIBLINGS NIL
    PARASITES (anaphora/test)) */
