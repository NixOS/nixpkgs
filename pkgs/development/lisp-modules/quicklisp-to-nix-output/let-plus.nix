args @ { fetchurl, ... }:
rec {
  baseName = ''let-plus'';
  version = ''20170124-git'';

  parasites = [ "let-plus-tests" ];

  description = ''Destructuring extension of LET*.'';

  deps = [ args."alexandria" args."anaphora" args."lift" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/let-plus/2017-01-24/let-plus-20170124-git.tgz'';
    sha256 = ''1hfsw4g36vccz2lx6gk375arjj6y85yh9ch3pq7yiybjlxx68xi8'';
  };

  packageName = "let-plus";

  asdFilesToKeep = ["let-plus.asd"];
  overrides = x: x;
}
/* (SYSTEM let-plus DESCRIPTION Destructuring extension of LET*. SHA256
    1hfsw4g36vccz2lx6gk375arjj6y85yh9ch3pq7yiybjlxx68xi8 URL
    http://beta.quicklisp.org/archive/let-plus/2017-01-24/let-plus-20170124-git.tgz
    MD5 1180608e4da53f3866a99d4cca72e3b1 NAME let-plus FILENAME let-plus DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME lift FILENAME lift))
    DEPENDENCIES (alexandria anaphora lift) VERSION 20170124-git SIBLINGS NIL
    PARASITES (let-plus-tests)) */
