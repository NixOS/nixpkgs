args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-indent'';
  version = ''20191007-git'';

  description = ''A very simple library to allow indentation hints for SWANK.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-indent/2019-10-07/trivial-indent-20191007-git.tgz'';
    sha256 = ''0v5isxg6lfbgcpmndb3c515d7bswhwqgjm97li85w39krnw1bfmv'';
  };

  packageName = "trivial-indent";

  asdFilesToKeep = ["trivial-indent.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-indent DESCRIPTION
    A very simple library to allow indentation hints for SWANK. SHA256
    0v5isxg6lfbgcpmndb3c515d7bswhwqgjm97li85w39krnw1bfmv URL
    http://beta.quicklisp.org/archive/trivial-indent/2019-10-07/trivial-indent-20191007-git.tgz
    MD5 d0489ff824d58c03b5c2a9b16279f583 NAME trivial-indent FILENAME
    trivial-indent DEPS NIL DEPENDENCIES NIL VERSION 20191007-git SIBLINGS NIL
    PARASITES NIL) */
