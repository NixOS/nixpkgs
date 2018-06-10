args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-indent'';
  version = ''20180131-git'';

  description = ''A very simple library to allow indentation hints for SWANK.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-indent/2018-01-31/trivial-indent-20180131-git.tgz'';
    sha256 = ''1y6m9nrhj923zj95824w7vsciqhv9cq7sq5x519x2ik0jfcaqp8w'';
  };

  packageName = "trivial-indent";

  asdFilesToKeep = ["trivial-indent.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-indent DESCRIPTION
    A very simple library to allow indentation hints for SWANK. SHA256
    1y6m9nrhj923zj95824w7vsciqhv9cq7sq5x519x2ik0jfcaqp8w URL
    http://beta.quicklisp.org/archive/trivial-indent/2018-01-31/trivial-indent-20180131-git.tgz
    MD5 a915258466d07465da1f71476bf59d12 NAME trivial-indent FILENAME
    trivial-indent DEPS NIL DEPENDENCIES NIL VERSION 20180131-git SIBLINGS NIL
    PARASITES NIL) */
