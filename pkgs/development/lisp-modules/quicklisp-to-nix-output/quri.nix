/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "quri";
  version = "20210630-git";

  description = "Yet another URI library for Common Lisp";

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/quri/2021-06-30/quri-20210630-git.tgz";
    sha256 = "0ihgsqdzi9rh8ybc221g46c5h7i4vrz67znwv76rm2z44v8x0wwh";
  };

  packageName = "quri";

  asdFilesToKeep = ["quri.asd"];
  overrides = x: x;
}
/* (SYSTEM quri DESCRIPTION Yet another URI library for Common Lisp SHA256
    0ihgsqdzi9rh8ybc221g46c5h7i4vrz67znwv76rm2z44v8x0wwh URL
    http://beta.quicklisp.org/archive/quri/2021-06-30/quri-20210630-git.tgz MD5
    3dcaaa9b94f6e4a0c5f4bd0829a045a7 NAME quri FILENAME quri DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-utilities split-sequence trivial-features) VERSION
    20210630-git SIBLINGS (quri-test) PARASITES NIL) */
