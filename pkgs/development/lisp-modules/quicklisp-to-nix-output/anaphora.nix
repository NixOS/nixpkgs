/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "anaphora";
  version = "20220220-git";

  parasites = [ "anaphora/test" ];

  description = "The Anaphoric Macro Package from Hell";

  deps = [ args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/anaphora/2022-02-20/anaphora-20220220-git.tgz";
    sha256 = "0jjf46m2jab7qnkw2s9hn91lvb2d1a9h4z78d34z68zklag4y4gp";
  };

  packageName = "anaphora";

  asdFilesToKeep = ["anaphora.asd"];
  overrides = x: x;
}
/* (SYSTEM anaphora DESCRIPTION The Anaphoric Macro Package from Hell SHA256
    0jjf46m2jab7qnkw2s9hn91lvb2d1a9h4z78d34z68zklag4y4gp URL
    http://beta.quicklisp.org/archive/anaphora/2022-02-20/anaphora-20220220-git.tgz
    MD5 f773589c518c8fd4d1be7baf2ff757a3 NAME anaphora FILENAME anaphora DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20220220-git SIBLINGS NIL
    PARASITES (anaphora/test)) */
