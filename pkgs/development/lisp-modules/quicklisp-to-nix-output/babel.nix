args @ { fetchurl, ... }:
rec {
  baseName = ''babel'';
  version = ''20170630-git'';

  description = ''Babel, a charset conversion library.'';

  deps = [ args."alexandria" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2017-06-30/babel-20170630-git.tgz'';
    sha256 = ''0w1jfzdklk5zz9vgplr2a0vc6gybrwl8wa72nj6xs4ihp7spf0lx'';
  };

  packageName = "babel";

  asdFilesToKeep = ["babel.asd"];
  overrides = x: x;
}
/* (SYSTEM babel DESCRIPTION Babel, a charset conversion library. SHA256
    0w1jfzdklk5zz9vgplr2a0vc6gybrwl8wa72nj6xs4ihp7spf0lx URL
    http://beta.quicklisp.org/archive/babel/2017-06-30/babel-20170630-git.tgz
    MD5 aa7eff848b97bb7f7aa6bdb43a081964 NAME babel FILENAME babel DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria trivial-features) VERSION 20170630-git SIBLINGS
    (babel-streams babel-tests) PARASITES NIL) */
