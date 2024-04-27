/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-arguments";
  version = "20200925-git";

  description = "A simple library to retrieve the lambda-list of a function.";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-arguments/2020-09-25/trivial-arguments-20200925-git.tgz";
    sha256 = "079xm6f1vmsng7dzgb2x3m7k46jfw19wskwf1l5cid5nm267d295";
  };

  packageName = "trivial-arguments";

  asdFilesToKeep = ["trivial-arguments.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-arguments DESCRIPTION
    A simple library to retrieve the lambda-list of a function. SHA256
    079xm6f1vmsng7dzgb2x3m7k46jfw19wskwf1l5cid5nm267d295 URL
    http://beta.quicklisp.org/archive/trivial-arguments/2020-09-25/trivial-arguments-20200925-git.tgz
    MD5 3d7b76a729b272019c8827e40bfb6db8 NAME trivial-arguments FILENAME
    trivial-arguments DEPS NIL DEPENDENCIES NIL VERSION 20200925-git SIBLINGS
    NIL PARASITES NIL) */
