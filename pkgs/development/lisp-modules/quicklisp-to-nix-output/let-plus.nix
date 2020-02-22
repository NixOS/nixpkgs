args @ { fetchurl, ... }:
rec {
  baseName = ''let-plus'';
  version = ''20171130-git'';

  parasites = [ "let-plus/tests" ];

  description = ''Destructuring extension of LET*.'';

  deps = [ args."alexandria" args."anaphora" args."lift" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/let-plus/2017-11-30/let-plus-20171130-git.tgz'';
    sha256 = ''1v8rp3ab6kp6v5kl58gi700wjs4qgmkxxkmhx2a1i6b2z934xkx7'';
  };

  packageName = "let-plus";

  asdFilesToKeep = ["let-plus.asd"];
  overrides = x: x;
}
/* (SYSTEM let-plus DESCRIPTION Destructuring extension of LET*. SHA256
    1v8rp3ab6kp6v5kl58gi700wjs4qgmkxxkmhx2a1i6b2z934xkx7 URL
    http://beta.quicklisp.org/archive/let-plus/2017-11-30/let-plus-20171130-git.tgz
    MD5 cd92097d436a513e7d0eac535617ca08 NAME let-plus FILENAME let-plus DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME lift FILENAME lift))
    DEPENDENCIES (alexandria anaphora lift) VERSION 20171130-git SIBLINGS NIL
    PARASITES (let-plus/tests)) */
