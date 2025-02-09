/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "quasiquote-2_dot_0";
  version = "20150505-git";

  parasites = [ "quasiquote-2.0-tests" ];

  description = "Writing macros that write macros. Effortless.";

  deps = [ args."fiveam" args."iterate" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/quasiquote-2.0/2015-05-05/quasiquote-2.0-20150505-git.tgz";
    sha256 = "0bgcqk7wp7qblw7avsawkg24zjiq9vgsbfa0yhk64avhxwjw6974";
  };

  packageName = "quasiquote-2.0";

  asdFilesToKeep = ["quasiquote-2.0.asd"];
  overrides = x: x;
}
/* (SYSTEM quasiquote-2.0 DESCRIPTION
    Writing macros that write macros. Effortless. SHA256
    0bgcqk7wp7qblw7avsawkg24zjiq9vgsbfa0yhk64avhxwjw6974 URL
    http://beta.quicklisp.org/archive/quasiquote-2.0/2015-05-05/quasiquote-2.0-20150505-git.tgz
    MD5 7c557e0c10cf7608afa5a20e4a83c778 NAME quasiquote-2.0 FILENAME
    quasiquote-2_dot_0 DEPS
    ((NAME fiveam FILENAME fiveam) (NAME iterate FILENAME iterate))
    DEPENDENCIES (fiveam iterate) VERSION 20150505-git SIBLINGS NIL PARASITES
    (quasiquote-2.0-tests)) */
