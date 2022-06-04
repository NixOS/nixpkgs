/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-ppcre-unicode";
  version = "cl-ppcre-20220220-git";

  parasites = [ "cl-ppcre-unicode/test" ];

  description = "Perl-compatible regular expression library (Unicode)";

  deps = [ args."cl-ppcre" args."cl-ppcre_slash_test" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-ppcre/2022-02-20/cl-ppcre-20220220-git.tgz";
    sha256 = "14s56h7l0w1r65qsh060kijqg6hzkpfma9qxd6h6l6qq0db69vxv";
  };

  packageName = "cl-ppcre-unicode";

  asdFilesToKeep = ["cl-ppcre-unicode.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ppcre-unicode DESCRIPTION
    Perl-compatible regular expression library (Unicode) SHA256
    14s56h7l0w1r65qsh060kijqg6hzkpfma9qxd6h6l6qq0db69vxv URL
    http://beta.quicklisp.org/archive/cl-ppcre/2022-02-20/cl-ppcre-20220220-git.tgz
    MD5 dfc08fa8887d446fb0d7f243c1b4e757 NAME cl-ppcre-unicode FILENAME
    cl-ppcre-unicode DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre/test FILENAME cl-ppcre_slash_test)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre cl-ppcre/test cl-unicode flexi-streams) VERSION
    cl-ppcre-20220220-git SIBLINGS (cl-ppcre) PARASITES (cl-ppcre-unicode/test)) */
