/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "osicat";
  version = "20211209-git";

  parasites = [ "osicat/tests" ];

  description = "A lightweight operating system interface";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."rt" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/osicat/2021-12-09/osicat-20211209-git.tgz";
    sha256 = "0c85aapyvr2f5c3lvpfv3hfdghwmsqf40qgyk9hwjva8s9242pgl";
  };

  packageName = "osicat";

  asdFilesToKeep = ["osicat.asd"];
  overrides = x: x;
}
/* (SYSTEM osicat DESCRIPTION A lightweight operating system interface SHA256
    0c85aapyvr2f5c3lvpfv3hfdghwmsqf40qgyk9hwjva8s9242pgl URL
    http://beta.quicklisp.org/archive/osicat/2021-12-09/osicat-20211209-git.tgz
    MD5 3581652999e0b16c6a1a8295585e7491 NAME osicat FILENAME osicat DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain) (NAME rt FILENAME rt)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain rt trivial-features)
    VERSION 20211209-git SIBLINGS NIL PARASITES (osicat/tests)) */
