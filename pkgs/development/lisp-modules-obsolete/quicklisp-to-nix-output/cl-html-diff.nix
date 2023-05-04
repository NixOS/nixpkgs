/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-html-diff";
  version = "20130128-git";

  description = "System lacks description";

  deps = [ args."cl-difflib" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-html-diff/2013-01-28/cl-html-diff-20130128-git.tgz";
    sha256 = "0dbqfgfl2qmlk91fncjj804md2crvj0bsvkdxfrsybrhn6dmikci";
  };

  packageName = "cl-html-diff";

  asdFilesToKeep = ["cl-html-diff.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-html-diff DESCRIPTION System lacks description SHA256
    0dbqfgfl2qmlk91fncjj804md2crvj0bsvkdxfrsybrhn6dmikci URL
    http://beta.quicklisp.org/archive/cl-html-diff/2013-01-28/cl-html-diff-20130128-git.tgz
    MD5 70f93e60e968dad9a44ede60856dc343 NAME cl-html-diff FILENAME
    cl-html-diff DEPS ((NAME cl-difflib FILENAME cl-difflib)) DEPENDENCIES
    (cl-difflib) VERSION 20130128-git SIBLINGS NIL PARASITES NIL) */
