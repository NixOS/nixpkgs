/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "anaphora";
  version = "20211209-git";

  parasites = [ "anaphora/test" ];

  description = "The Anaphoric Macro Package from Hell";

  deps = [ args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/anaphora/2021-12-09/anaphora-20211209-git.tgz";
    sha256 = "1pi166qwf3zwswhgq8c4r84rl5d6lnn0rkb3cdf5afyxmminsadg";
  };

  packageName = "anaphora";

  asdFilesToKeep = ["anaphora.asd"];
  overrides = x: x;
}
/* (SYSTEM anaphora DESCRIPTION The Anaphoric Macro Package from Hell SHA256
    1pi166qwf3zwswhgq8c4r84rl5d6lnn0rkb3cdf5afyxmminsadg URL
    http://beta.quicklisp.org/archive/anaphora/2021-12-09/anaphora-20211209-git.tgz
    MD5 81827cd43d29293e967916bb11c4df88 NAME anaphora FILENAME anaphora DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20211209-git SIBLINGS NIL
    PARASITES (anaphora/test)) */
