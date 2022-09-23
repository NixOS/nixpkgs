/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "defclass-std";
  version = "20201220-git";

  description = "A shortcut macro to write DEFCLASS forms quickly.";

  deps = [ args."alexandria" args."anaphora" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/defclass-std/2020-12-20/defclass-std-20201220-git.tgz";
    sha256 = "1ldivz1zmg0yxja43gj0lcgf10k0kj2bhb0576f0xnhy56sya0w3";
  };

  packageName = "defclass-std";

  asdFilesToKeep = ["defclass-std.asd"];
  overrides = x: x;
}
/* (SYSTEM defclass-std DESCRIPTION
    A shortcut macro to write DEFCLASS forms quickly. SHA256
    1ldivz1zmg0yxja43gj0lcgf10k0kj2bhb0576f0xnhy56sya0w3 URL
    http://beta.quicklisp.org/archive/defclass-std/2020-12-20/defclass-std-20201220-git.tgz
    MD5 b7a3bec06318b10818dc3941d407fe65 NAME defclass-std FILENAME
    defclass-std DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora))
    DEPENDENCIES (alexandria anaphora) VERSION 20201220-git SIBLINGS
    (defclass-std-test) PARASITES NIL) */
