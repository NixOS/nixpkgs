/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "quri";
  version = "20210411-git";

  description = "Yet another URI library for Common Lisp";

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/quri/2021-04-11/quri-20210411-git.tgz";
    sha256 = "1j4al77bl8awj7755g8zvgvfskdh6gcl3gygbz2fi6lrrk9125d7";
  };

  packageName = "quri";

  asdFilesToKeep = ["quri.asd"];
  overrides = x: x;
}
/* (SYSTEM quri DESCRIPTION Yet another URI library for Common Lisp SHA256
    1j4al77bl8awj7755g8zvgvfskdh6gcl3gygbz2fi6lrrk9125d7 URL
    http://beta.quicklisp.org/archive/quri/2021-04-11/quri-20210411-git.tgz MD5
    2727c706f51bef480171c59f6134bba5 NAME quri FILENAME quri DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-utilities split-sequence trivial-features) VERSION
    20210411-git SIBLINGS (quri-test) PARASITES NIL) */
