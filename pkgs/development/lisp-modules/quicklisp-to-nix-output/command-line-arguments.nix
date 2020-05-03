args @ { fetchurl, ... }:
rec {
  baseName = ''command-line-arguments'';
  version = ''20191227-git'';

  description = ''small library to deal with command-line arguments'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/command-line-arguments/2019-12-27/command-line-arguments-20191227-git.tgz'';
    sha256 = ''1846v22mdi8qfavp9wcp7spic6gcmlrbd6g3l0f3crssqza0asgf'';
  };

  packageName = "command-line-arguments";

  asdFilesToKeep = ["command-line-arguments.asd"];
  overrides = x: x;
}
/* (SYSTEM command-line-arguments DESCRIPTION
    small library to deal with command-line arguments SHA256
    1846v22mdi8qfavp9wcp7spic6gcmlrbd6g3l0f3crssqza0asgf URL
    http://beta.quicklisp.org/archive/command-line-arguments/2019-12-27/command-line-arguments-20191227-git.tgz
    MD5 3ed82e1536b55fc0b7abc79626631aab NAME command-line-arguments FILENAME
    command-line-arguments DEPS NIL DEPENDENCIES NIL VERSION 20191227-git
    SIBLINGS NIL PARASITES NIL) */
