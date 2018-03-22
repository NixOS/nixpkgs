args @ { fetchurl, ... }:
rec {
  baseName = ''_3bmd'';
  version = ''20171019-git'';

  description = ''markdown processor in CL using esrap parser.'';

  deps = [ args."alexandria" args."esrap" args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/3bmd/2017-10-19/3bmd-20171019-git.tgz'';
    sha256 = ''1lrh1ypn9wrjcayi9vc706knac1vsxlrzlsxq73apdc7jx4wzywz'';
  };

  packageName = "3bmd";

  asdFilesToKeep = ["3bmd.asd"];
  overrides = x: x;
}
/* (SYSTEM 3bmd DESCRIPTION markdown processor in CL using esrap parser. SHA256
    1lrh1ypn9wrjcayi9vc706knac1vsxlrzlsxq73apdc7jx4wzywz URL
    http://beta.quicklisp.org/archive/3bmd/2017-10-19/3bmd-20171019-git.tgz MD5
    d691962a511f2edc15f4fc228ecdf546 NAME 3bmd FILENAME _3bmd DEPS
    ((NAME alexandria FILENAME alexandria) (NAME esrap FILENAME esrap)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES (alexandria esrap split-sequence) VERSION 20171019-git
    SIBLINGS
    (3bmd-ext-code-blocks 3bmd-ext-definition-lists 3bmd-ext-tables
     3bmd-ext-wiki-links 3bmd-youtube-tests 3bmd-youtube)
    PARASITES NIL) */
