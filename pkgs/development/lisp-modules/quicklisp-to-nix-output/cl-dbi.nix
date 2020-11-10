args @ { fetchurl, ... }:
rec {
  baseName = ''cl-dbi'';
  version = ''20200610-git'';

  description = ''System lacks description'';

  deps = [ args."alexandria" args."bordeaux-threads" args."closer-mop" args."dbi" args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2020-06-10/cl-dbi-20200610-git.tgz'';
    sha256 = ''1d7hwywcqzqwmr5b42c0mmjq3v3xxd4cwb4fn5k1wd7j6pr0bkas'';
  };

  packageName = "cl-dbi";

  asdFilesToKeep = ["cl-dbi.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-dbi DESCRIPTION System lacks description SHA256
    1d7hwywcqzqwmr5b42c0mmjq3v3xxd4cwb4fn5k1wd7j6pr0bkas URL
    http://beta.quicklisp.org/archive/cl-dbi/2020-06-10/cl-dbi-20200610-git.tgz
    MD5 2caeb911b23327e054986211d6bfea55 NAME cl-dbi FILENAME cl-dbi DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME closer-mop FILENAME closer-mop) (NAME dbi FILENAME dbi)
     (NAME split-sequence FILENAME split-sequence))
    DEPENDENCIES (alexandria bordeaux-threads closer-mop dbi split-sequence)
    VERSION 20200610-git SIBLINGS
    (dbd-mysql dbd-postgres dbd-sqlite3 dbi-test dbi) PARASITES NIL) */
