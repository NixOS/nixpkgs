/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "osicat";
  version = "20210228-git";

  parasites = [ "osicat/tests" ];

  description = "A lightweight operating system interface";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."rt" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/osicat/2021-02-28/osicat-20210228-git.tgz";
    sha256 = "0g9frahjr2i6fvwd3bzvcz9icx4n4mnwcmsz6gvg5s6wmq5ny6wb";
  };

  packageName = "osicat";

  asdFilesToKeep = ["osicat.asd"];
  overrides = x: x;
}
/* (SYSTEM osicat DESCRIPTION A lightweight operating system interface SHA256
    0g9frahjr2i6fvwd3bzvcz9icx4n4mnwcmsz6gvg5s6wmq5ny6wb URL
    http://beta.quicklisp.org/archive/osicat/2021-02-28/osicat-20210228-git.tgz
    MD5 22c1b81abfe4fb30a2789877d2f85a86 NAME osicat FILENAME osicat DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain) (NAME rt FILENAME rt)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain rt trivial-features)
    VERSION 20210228-git SIBLINGS NIL PARASITES (osicat/tests)) */
