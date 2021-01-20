args @ { fetchurl, ... }:
rec {
  baseName = ''dbi-test'';
  version = ''cl-dbi-20200610-git'';

  description = ''System lacks description'';

  deps = [ args."alexandria" args."bordeaux-threads" args."closer-mop" args."dbi" args."dissect" args."rove" args."split-sequence" args."trivial-gray-streams" args."trivial-types" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2020-06-10/cl-dbi-20200610-git.tgz'';
    sha256 = ''1d7hwywcqzqwmr5b42c0mmjq3v3xxd4cwb4fn5k1wd7j6pr0bkas'';
  };

  packageName = "dbi-test";

  asdFilesToKeep = ["dbi-test.asd"];
  overrides = x: x;
}
/* (SYSTEM dbi-test DESCRIPTION System lacks description SHA256
    1d7hwywcqzqwmr5b42c0mmjq3v3xxd4cwb4fn5k1wd7j6pr0bkas URL
    http://beta.quicklisp.org/archive/cl-dbi/2020-06-10/cl-dbi-20200610-git.tgz
    MD5 2caeb911b23327e054986211d6bfea55 NAME dbi-test FILENAME dbi-test DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME closer-mop FILENAME closer-mop) (NAME dbi FILENAME dbi)
     (NAME dissect FILENAME dissect) (NAME rove FILENAME rove)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES
    (alexandria bordeaux-threads closer-mop dbi dissect rove split-sequence
     trivial-gray-streams trivial-types)
    VERSION cl-dbi-20200610-git SIBLINGS
    (cl-dbi dbd-mysql dbd-postgres dbd-sqlite3 dbi) PARASITES NIL) */
