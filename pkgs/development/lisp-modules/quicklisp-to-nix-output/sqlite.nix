args @ { fetchurl, ... }:
rec {
  baseName = ''sqlite'';
  version = ''cl-20190813-git'';

  description = ''CL-SQLITE package is an interface to the SQLite embedded relational database engine.'';

  deps = [ args."alexandria" args."babel" args."cffi" args."iterate" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-sqlite/2019-08-13/cl-sqlite-20190813-git.tgz'';
    sha256 = ''07zla2h7i7ggmzsyj33f12vpxvcbbvq6x022c2dy13flx8a83rmk'';
  };

  packageName = "sqlite";

  asdFilesToKeep = ["sqlite.asd"];
  overrides = x: x;
}
/* (SYSTEM sqlite DESCRIPTION
    CL-SQLITE package is an interface to the SQLite embedded relational database engine.
    SHA256 07zla2h7i7ggmzsyj33f12vpxvcbbvq6x022c2dy13flx8a83rmk URL
    http://beta.quicklisp.org/archive/cl-sqlite/2019-08-13/cl-sqlite-20190813-git.tgz
    MD5 2269773eeb4a101ddd3b33f0f7e05e76 NAME sqlite FILENAME sqlite DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME iterate FILENAME iterate)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi iterate trivial-features) VERSION
    cl-20190813-git SIBLINGS NIL PARASITES NIL) */
