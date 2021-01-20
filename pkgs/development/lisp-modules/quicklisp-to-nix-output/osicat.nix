args @ { fetchurl, ... }:
rec {
  baseName = ''osicat'';
  version = ''20200925-git'';

  parasites = [ "osicat/tests" ];

  description = ''A lightweight operating system interface'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."rt" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/osicat/2020-09-25/osicat-20200925-git.tgz'';
    sha256 = ''191ncd5arfx6i9cw3iny4a473wsrr3dpv2lwb9jr02p6qpmqwysk'';
  };

  packageName = "osicat";

  asdFilesToKeep = ["osicat.asd"];
  overrides = x: x;
}
/* (SYSTEM osicat DESCRIPTION A lightweight operating system interface SHA256
    191ncd5arfx6i9cw3iny4a473wsrr3dpv2lwb9jr02p6qpmqwysk URL
    http://beta.quicklisp.org/archive/osicat/2020-09-25/osicat-20200925-git.tgz
    MD5 5d0a254f2b8041a71fa6fa90eabaed70 NAME osicat FILENAME osicat DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain) (NAME rt FILENAME rt)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain rt trivial-features)
    VERSION 20200925-git SIBLINGS NIL PARASITES (osicat/tests)) */
