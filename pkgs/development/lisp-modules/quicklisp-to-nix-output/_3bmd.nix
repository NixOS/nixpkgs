args @ { fetchurl, ... }:
rec {
  baseName = ''_3bmd'';
  version = ''20200925-git'';

  description = ''markdown processor in CL using esrap parser.'';

  deps = [ args."alexandria" args."esrap" args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/3bmd/2020-09-25/3bmd-20200925-git.tgz'';
    sha256 = ''0sk4b0xma4vv6ssiskbz7h5bw8v8glm34mbv3llqywb50b9ks4fw'';
  };

  packageName = "3bmd";

  asdFilesToKeep = ["3bmd.asd"];
  overrides = x: x;
}
/* (SYSTEM 3bmd DESCRIPTION markdown processor in CL using esrap parser. SHA256
    0sk4b0xma4vv6ssiskbz7h5bw8v8glm34mbv3llqywb50b9ks4fw URL
    http://beta.quicklisp.org/archive/3bmd/2020-09-25/3bmd-20200925-git.tgz MD5
    3b2c0b2094e473234742d150ac84abdd NAME 3bmd FILENAME _3bmd DEPS
    ((NAME alexandria FILENAME alexandria) (NAME esrap FILENAME esrap)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES (alexandria esrap split-sequence) VERSION 20200925-git
    SIBLINGS
    (3bmd-ext-code-blocks 3bmd-ext-definition-lists 3bmd-ext-math
     3bmd-ext-tables 3bmd-ext-wiki-links 3bmd-youtube-tests 3bmd-youtube)
    PARASITES NIL) */
