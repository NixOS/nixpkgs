args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-indent'';
  version = ''20170630-git'';

  description = ''A very simple library to allow indentation hints for SWANK.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-indent/2017-06-30/trivial-indent-20170630-git.tgz'';
    sha256 = ''18zag7n2yfjx3x6nm8132cq8lz321i3f3zslb90j198wvpwyrnq7'';
  };

  packageName = "trivial-indent";

  asdFilesToKeep = ["trivial-indent.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-indent DESCRIPTION
    A very simple library to allow indentation hints for SWANK. SHA256
    18zag7n2yfjx3x6nm8132cq8lz321i3f3zslb90j198wvpwyrnq7 URL
    http://beta.quicklisp.org/archive/trivial-indent/2017-06-30/trivial-indent-20170630-git.tgz
    MD5 9f11cc1014be3e3ae588a3cd07315be6 NAME trivial-indent FILENAME
    trivial-indent DEPS NIL DEPENDENCIES NIL VERSION 20170630-git SIBLINGS NIL
    PARASITES NIL) */
