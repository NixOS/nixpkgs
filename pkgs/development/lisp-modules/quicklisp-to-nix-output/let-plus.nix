args @ { fetchurl, ... }:
rec {
  baseName = ''let-plus'';
  version = ''20191130-git'';

  parasites = [ "let-plus/tests" ];

  description = ''Destructuring extension of LET*.'';

  deps = [ args."alexandria" args."anaphora" args."lift" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/let-plus/2019-11-30/let-plus-20191130-git.tgz'';
    sha256 = ''0zj0fgb7lvczgpz4jq8q851p77kma7ikn7hd2jk2c37iv4nmz29p'';
  };

  packageName = "let-plus";

  asdFilesToKeep = ["let-plus.asd"];
  overrides = x: x;
}
/* (SYSTEM let-plus DESCRIPTION Destructuring extension of LET*. SHA256
    0zj0fgb7lvczgpz4jq8q851p77kma7ikn7hd2jk2c37iv4nmz29p URL
    http://beta.quicklisp.org/archive/let-plus/2019-11-30/let-plus-20191130-git.tgz
    MD5 1b8d1660ed67852ea31cad44a6fc15d0 NAME let-plus FILENAME let-plus DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME lift FILENAME lift))
    DEPENDENCIES (alexandria anaphora lift) VERSION 20191130-git SIBLINGS NIL
    PARASITES (let-plus/tests)) */
