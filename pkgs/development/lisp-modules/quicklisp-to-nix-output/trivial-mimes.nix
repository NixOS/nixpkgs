args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-mimes'';
  version = ''20170630-git'';

  description = ''Tiny library to detect mime types in files.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-mimes/2017-06-30/trivial-mimes-20170630-git.tgz'';
    sha256 = ''0rm667w7nfkcrfjqbb7blbdcrjxbr397a6nqmy35qq82fqjr4rvx'';
  };

  packageName = "trivial-mimes";

  asdFilesToKeep = ["trivial-mimes.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-mimes DESCRIPTION
    Tiny library to detect mime types in files. SHA256
    0rm667w7nfkcrfjqbb7blbdcrjxbr397a6nqmy35qq82fqjr4rvx URL
    http://beta.quicklisp.org/archive/trivial-mimes/2017-06-30/trivial-mimes-20170630-git.tgz
    MD5 5aecea17e102bd2dab7e71fecd1f8e44 NAME trivial-mimes FILENAME
    trivial-mimes DEPS NIL DEPENDENCIES NIL VERSION 20170630-git SIBLINGS NIL
    PARASITES NIL) */
