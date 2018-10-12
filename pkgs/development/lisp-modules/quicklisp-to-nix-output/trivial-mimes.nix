args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-mimes'';
  version = ''20180831-git'';

  description = ''Tiny library to detect mime types in files.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-mimes/2018-08-31/trivial-mimes-20180831-git.tgz'';
    sha256 = ''0nkf6ifjvh4fvmf7spmqmz64yh2l1f25gxq1r8s0z0vnrmpsggqr'';
  };

  packageName = "trivial-mimes";

  asdFilesToKeep = ["trivial-mimes.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-mimes DESCRIPTION
    Tiny library to detect mime types in files. SHA256
    0nkf6ifjvh4fvmf7spmqmz64yh2l1f25gxq1r8s0z0vnrmpsggqr URL
    http://beta.quicklisp.org/archive/trivial-mimes/2018-08-31/trivial-mimes-20180831-git.tgz
    MD5 503680e90278947d888bcbe3338c74e3 NAME trivial-mimes FILENAME
    trivial-mimes DEPS NIL DEPENDENCIES NIL VERSION 20180831-git SIBLINGS NIL
    PARASITES NIL) */
