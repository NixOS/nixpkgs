args @ { fetchurl, ... }:
rec {
  baseName = ''command-line-arguments'';
  version = ''20151218-git'';

  description = ''small library to deal with command-line arguments'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/command-line-arguments/2015-12-18/command-line-arguments-20151218-git.tgz'';
    sha256 = ''07yv3vj9kjd84q09d6kvgryqxb71bsa7jl22fd1an6inmk0a3yyh'';
  };

  packageName = "command-line-arguments";

  asdFilesToKeep = ["command-line-arguments.asd"];
  overrides = x: x;
}
/* (SYSTEM command-line-arguments DESCRIPTION
    small library to deal with command-line arguments SHA256
    07yv3vj9kjd84q09d6kvgryqxb71bsa7jl22fd1an6inmk0a3yyh URL
    http://beta.quicklisp.org/archive/command-line-arguments/2015-12-18/command-line-arguments-20151218-git.tgz
    MD5 8cdb99db40143e34cf6b0b25ca95f826 NAME command-line-arguments FILENAME
    command-line-arguments DEPS NIL DEPENDENCIES NIL VERSION 20151218-git
    SIBLINGS NIL PARASITES NIL) */
