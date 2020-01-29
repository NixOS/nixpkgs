args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-indent'';
  version = ''20190710-git'';

  description = ''A very simple library to allow indentation hints for SWANK.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-indent/2019-07-10/trivial-indent-20190710-git.tgz'';
    sha256 = ''00s35j8cf1ivwc1l55wprx1a78mvnxaz6innwwb3jan1sl3caycx'';
  };

  packageName = "trivial-indent";

  asdFilesToKeep = ["trivial-indent.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-indent DESCRIPTION
    A very simple library to allow indentation hints for SWANK. SHA256
    00s35j8cf1ivwc1l55wprx1a78mvnxaz6innwwb3jan1sl3caycx URL
    http://beta.quicklisp.org/archive/trivial-indent/2019-07-10/trivial-indent-20190710-git.tgz
    MD5 a5026ac3d68e02fce100761e546a0d77 NAME trivial-indent FILENAME
    trivial-indent DEPS NIL DEPENDENCIES NIL VERSION 20190710-git SIBLINGS NIL
    PARASITES NIL) */
