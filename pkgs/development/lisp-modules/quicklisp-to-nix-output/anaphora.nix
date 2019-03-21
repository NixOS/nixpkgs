args @ { fetchurl, ... }:
rec {
  baseName = ''anaphora'';
  version = ''20180228-git'';

  parasites = [ "anaphora/test" ];

  description = ''The Anaphoric Macro Package from Hell'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/anaphora/2018-02-28/anaphora-20180228-git.tgz'';
    sha256 = ''1bd2mvrxdf460wqrmg93lrvrjzvhbxjq8fcpvh24afx6573g2d41'';
  };

  packageName = "anaphora";

  asdFilesToKeep = ["anaphora.asd"];
  overrides = x: x;
}
/* (SYSTEM anaphora DESCRIPTION The Anaphoric Macro Package from Hell SHA256
    1bd2mvrxdf460wqrmg93lrvrjzvhbxjq8fcpvh24afx6573g2d41 URL
    http://beta.quicklisp.org/archive/anaphora/2018-02-28/anaphora-20180228-git.tgz
    MD5 a884be2d820c0bc7dc59dea7ffd72731 NAME anaphora FILENAME anaphora DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20180228-git SIBLINGS NIL
    PARASITES (anaphora/test)) */
