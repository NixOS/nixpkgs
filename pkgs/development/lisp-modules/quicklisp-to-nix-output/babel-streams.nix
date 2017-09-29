args @ { fetchurl, ... }:
rec {
  baseName = ''babel-streams'';
  version = ''babel-20170630-git'';

  description = ''Some useful streams based on Babel's encoding code'';

  deps = [ args."alexandria" args."babel" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2017-06-30/babel-20170630-git.tgz'';
    sha256 = ''0w1jfzdklk5zz9vgplr2a0vc6gybrwl8wa72nj6xs4ihp7spf0lx'';
  };

  packageName = "babel-streams";

  asdFilesToKeep = ["babel-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM babel-streams DESCRIPTION
    Some useful streams based on Babel's encoding code SHA256
    0w1jfzdklk5zz9vgplr2a0vc6gybrwl8wa72nj6xs4ihp7spf0lx URL
    http://beta.quicklisp.org/archive/babel/2017-06-30/babel-20170630-git.tgz
    MD5 aa7eff848b97bb7f7aa6bdb43a081964 NAME babel-streams FILENAME
    babel-streams DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria babel trivial-features trivial-gray-streams)
    VERSION babel-20170630-git SIBLINGS (babel-tests babel) PARASITES NIL) */
