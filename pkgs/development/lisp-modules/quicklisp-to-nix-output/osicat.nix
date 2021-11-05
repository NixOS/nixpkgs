/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "osicat";
  version = "20211020-git";

  parasites = [ "osicat/tests" ];

  description = "A lightweight operating system interface";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."rt" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/osicat/2021-10-20/osicat-20211020-git.tgz";
    sha256 = "0rb53m4hg8dllljjvj9a76mq4hn9cl7wp0lqg50gs0l6v2c7qlbw";
  };

  packageName = "osicat";

  asdFilesToKeep = ["osicat.asd"];
  overrides = x: x;
}
/* (SYSTEM osicat DESCRIPTION A lightweight operating system interface SHA256
    0rb53m4hg8dllljjvj9a76mq4hn9cl7wp0lqg50gs0l6v2c7qlbw URL
    http://beta.quicklisp.org/archive/osicat/2021-10-20/osicat-20211020-git.tgz
    MD5 2cf6739bb39a2bf414de19037f867c87 NAME osicat FILENAME osicat DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain) (NAME rt FILENAME rt)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain rt trivial-features)
    VERSION 20211020-git SIBLINGS NIL PARASITES (osicat/tests)) */
