/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "kmrcl";
  version = "20201016-git";

  parasites = [ "kmrcl/test" ];

  description = "System lacks description";

  deps = [ args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/kmrcl/2020-10-16/kmrcl-20201016-git.tgz";
    sha256 = "0i0k61385hrzbg15qs1wprz6sis7mx2abxv1hqcc2f53rqm9b2hf";
  };

  packageName = "kmrcl";

  asdFilesToKeep = ["kmrcl.asd"];
  overrides = x: x;
}
/* (SYSTEM kmrcl DESCRIPTION System lacks description SHA256
    0i0k61385hrzbg15qs1wprz6sis7mx2abxv1hqcc2f53rqm9b2hf URL
    http://beta.quicklisp.org/archive/kmrcl/2020-10-16/kmrcl-20201016-git.tgz
    MD5 f86bc410907f748c3c453469702755b8 NAME kmrcl FILENAME kmrcl DEPS
    ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION 20201016-git SIBLINGS NIL
    PARASITES (kmrcl/test)) */
