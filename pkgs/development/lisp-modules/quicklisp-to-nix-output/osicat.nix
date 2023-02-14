/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "osicat";
  version = "20220220-git";

  parasites = [ "osicat/tests" ];

  description = "A lightweight operating system interface";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."rt" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/osicat/2022-02-20/osicat-20220220-git.tgz";
    sha256 = "1mq2kim5v5mah9qds56z370bim0gc1ymxq41xp0i553dwhcmchdq";
  };

  packageName = "osicat";

  asdFilesToKeep = ["osicat.asd"];
  overrides = x: x;
}
/* (SYSTEM osicat DESCRIPTION A lightweight operating system interface SHA256
    1mq2kim5v5mah9qds56z370bim0gc1ymxq41xp0i553dwhcmchdq URL
    http://beta.quicklisp.org/archive/osicat/2022-02-20/osicat-20220220-git.tgz
    MD5 8013cfd6decb2e75e888fd4e7b703f73 NAME osicat FILENAME osicat DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain) (NAME rt FILENAME rt)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain rt trivial-features)
    VERSION 20220220-git SIBLINGS NIL PARASITES (osicat/tests)) */
