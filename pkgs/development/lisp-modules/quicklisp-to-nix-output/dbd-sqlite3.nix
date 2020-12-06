args @ { fetchurl, ... }:
rec {
  baseName = ''dbd-sqlite3'';
  version = ''cl-dbi-20200610-git'';

  description = ''Database driver for SQLite3.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."closer-mop" args."dbi" args."iterate" args."split-sequence" args."sqlite" args."trivial-features" args."trivial-garbage" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2020-06-10/cl-dbi-20200610-git.tgz'';
    sha256 = ''1d7hwywcqzqwmr5b42c0mmjq3v3xxd4cwb4fn5k1wd7j6pr0bkas'';
  };

  packageName = "dbd-sqlite3";

  asdFilesToKeep = ["dbd-sqlite3.asd"];
  overrides = x: x;
}
/* (SYSTEM dbd-sqlite3 DESCRIPTION Database driver for SQLite3. SHA256
    1d7hwywcqzqwmr5b42c0mmjq3v3xxd4cwb4fn5k1wd7j6pr0bkas URL
    http://beta.quicklisp.org/archive/cl-dbi/2020-06-10/cl-dbi-20200610-git.tgz
    MD5 2caeb911b23327e054986211d6bfea55 NAME dbd-sqlite3 FILENAME dbd-sqlite3
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME closer-mop FILENAME closer-mop)
     (NAME dbi FILENAME dbi) (NAME iterate FILENAME iterate)
     (NAME split-sequence FILENAME split-sequence)
     (NAME sqlite FILENAME sqlite)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi closer-mop dbi iterate
     split-sequence sqlite trivial-features trivial-garbage)
    VERSION cl-dbi-20200610-git SIBLINGS
    (cl-dbi dbd-mysql dbd-postgres dbi-test dbi) PARASITES NIL) */
