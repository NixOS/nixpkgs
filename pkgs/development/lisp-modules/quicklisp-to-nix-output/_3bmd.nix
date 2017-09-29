args @ { fetchurl, ... }:
rec {
  baseName = ''_3bmd'';
  version = ''20161204-git'';

  description = ''markdown processor in CL using esrap parser.'';

  deps = [ args."alexandria" args."esrap" args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/3bmd/2016-12-04/3bmd-20161204-git.tgz'';
    sha256 = ''158rymq6ra9ipmkqrqmgr4ay5m46cdxxha03622svllhyf7xzypx'';
  };

  packageName = "3bmd";

  asdFilesToKeep = ["3bmd.asd"];
  overrides = x: x;
}
/* (SYSTEM 3bmd DESCRIPTION markdown processor in CL using esrap parser. SHA256
    158rymq6ra9ipmkqrqmgr4ay5m46cdxxha03622svllhyf7xzypx URL
    http://beta.quicklisp.org/archive/3bmd/2016-12-04/3bmd-20161204-git.tgz MD5
    b80864c74437e0cfb66663e9bbf08fed NAME 3bmd FILENAME _3bmd DEPS
    ((NAME alexandria FILENAME alexandria) (NAME esrap FILENAME esrap)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES (alexandria esrap split-sequence) VERSION 20161204-git
    SIBLINGS
    (3bmd-ext-code-blocks 3bmd-ext-definition-lists 3bmd-ext-tables
     3bmd-ext-wiki-links 3bmd-youtube-tests 3bmd-youtube)
    PARASITES NIL) */
