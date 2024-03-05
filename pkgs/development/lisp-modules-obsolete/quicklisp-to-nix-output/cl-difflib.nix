/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-difflib";
  version = "20130128-git";

  description = "A Lisp library for computing differences between sequences.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-difflib/2013-01-28/cl-difflib-20130128-git.tgz";
    sha256 = "1bgb0nmm93x90c7v1q1ah1v5dfm2anhkim7nh88sg7kg50y4ksm6";
  };

  packageName = "cl-difflib";

  asdFilesToKeep = ["cl-difflib.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-difflib DESCRIPTION
    A Lisp library for computing differences between sequences. SHA256
    1bgb0nmm93x90c7v1q1ah1v5dfm2anhkim7nh88sg7kg50y4ksm6 URL
    http://beta.quicklisp.org/archive/cl-difflib/2013-01-28/cl-difflib-20130128-git.tgz
    MD5 e8a3434843a368373b67d09983d2b809 NAME cl-difflib FILENAME cl-difflib
    DEPS NIL DEPENDENCIES NIL VERSION 20130128-git SIBLINGS (cl-difflib-tests)
    PARASITES NIL) */
