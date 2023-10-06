/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "alexandria";
  version = "20211209-git";

  description = "Alexandria is a collection of portable public domain utilities.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/alexandria/2021-12-09/alexandria-20211209-git.tgz";
    sha256 = "13xyajg5n3ad3x2hrmzni1w87b0wc41wn7manbvc3dc5n55afxk0";
  };

  packageName = "alexandria";

  asdFilesToKeep = ["alexandria.asd"];
  overrides = x: x;
}
/* (SYSTEM alexandria DESCRIPTION
    Alexandria is a collection of portable public domain utilities. SHA256
    13xyajg5n3ad3x2hrmzni1w87b0wc41wn7manbvc3dc5n55afxk0 URL
    http://beta.quicklisp.org/archive/alexandria/2021-12-09/alexandria-20211209-git.tgz
    MD5 4f578a956567ea0d6c99c2babd1752f3 NAME alexandria FILENAME alexandria
    DEPS NIL DEPENDENCIES NIL VERSION 20211209-git SIBLINGS (alexandria-tests)
    PARASITES NIL) */
