/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-ppcre";
  version = "20220220-git";

  parasites = [ "cl-ppcre/test" ];

  description = "Perl-compatible regular expression library";

  deps = [ args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-ppcre/2022-02-20/cl-ppcre-20220220-git.tgz";
    sha256 = "14s56h7l0w1r65qsh060kijqg6hzkpfma9qxd6h6l6qq0db69vxv";
  };

  packageName = "cl-ppcre";

  asdFilesToKeep = ["cl-ppcre.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ppcre DESCRIPTION Perl-compatible regular expression library
    SHA256 14s56h7l0w1r65qsh060kijqg6hzkpfma9qxd6h6l6qq0db69vxv URL
    http://beta.quicklisp.org/archive/cl-ppcre/2022-02-20/cl-ppcre-20220220-git.tgz
    MD5 dfc08fa8887d446fb0d7f243c1b4e757 NAME cl-ppcre FILENAME cl-ppcre DEPS
    ((NAME flexi-streams FILENAME flexi-streams)) DEPENDENCIES (flexi-streams)
    VERSION 20220220-git SIBLINGS (cl-ppcre-unicode) PARASITES (cl-ppcre/test)) */
