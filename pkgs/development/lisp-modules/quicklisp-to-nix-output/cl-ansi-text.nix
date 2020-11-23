args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ansi-text'';
  version = ''20200218-git'';

  description = ''ANSI control string characters, focused on color'';

  deps = [ args."alexandria" args."cl-colors2" args."cl-ppcre" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ansi-text/2020-02-18/cl-ansi-text-20200218-git.tgz'';
    sha256 = ''1yn657rka3pcg3p5g9czbpk0f0rv81dbq1gknid1b24zg7krks5r'';
  };

  packageName = "cl-ansi-text";

  asdFilesToKeep = ["cl-ansi-text.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ansi-text DESCRIPTION
    ANSI control string characters, focused on color SHA256
    1yn657rka3pcg3p5g9czbpk0f0rv81dbq1gknid1b24zg7krks5r URL
    http://beta.quicklisp.org/archive/cl-ansi-text/2020-02-18/cl-ansi-text-20200218-git.tgz
    MD5 2fccf2a06d73237ab421d9e62a2c6bd2 NAME cl-ansi-text FILENAME
    cl-ansi-text DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-colors2 FILENAME cl-colors2) (NAME cl-ppcre FILENAME cl-ppcre))
    DEPENDENCIES (alexandria cl-colors2 cl-ppcre) VERSION 20200218-git SIBLINGS
    (cl-ansi-text.test) PARASITES NIL) */
