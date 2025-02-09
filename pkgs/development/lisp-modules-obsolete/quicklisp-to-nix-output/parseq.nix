/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "parseq";
  version = "20210531-git";

  parasites = [ "parseq/test" ];

  description = "A library for parsing sequences such as strings and lists using parsing expression grammars.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/parseq/2021-05-31/parseq-20210531-git.tgz";
    sha256 = "1jh362avz2bbjrg9wwnjisa3ikxjxcgbddc0gqx65l6h9s87gqrg";
  };

  packageName = "parseq";

  asdFilesToKeep = ["parseq.asd"];
  overrides = x: x;
}
/* (SYSTEM parseq DESCRIPTION
    A library for parsing sequences such as strings and lists using parsing expression grammars.
    SHA256 1jh362avz2bbjrg9wwnjisa3ikxjxcgbddc0gqx65l6h9s87gqrg URL
    http://beta.quicklisp.org/archive/parseq/2021-05-31/parseq-20210531-git.tgz
    MD5 a62fdb0623450f7ef82297e8b23fd343 NAME parseq FILENAME parseq DEPS NIL
    DEPENDENCIES NIL VERSION 20210531-git SIBLINGS NIL PARASITES (parseq/test)) */
