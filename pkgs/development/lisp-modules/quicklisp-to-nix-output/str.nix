args @ { fetchurl, ... }:
rec {
  baseName = ''str'';
  version = ''cl-20200925-git'';

  description = ''Modern, consistent and terse Common Lisp string manipulation library.'';

  deps = [ args."cl-change-case" args."cl-ppcre" args."cl-ppcre-unicode" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-str/2020-09-25/cl-str-20200925-git.tgz'';
    sha256 = ''06k81x80vjw7qd8gca6lnm5k5ws40c6kl99s7m4z72v7jxwa9ykn'';
  };

  packageName = "str";

  asdFilesToKeep = ["str.asd"];
  overrides = x: x;
}
/* (SYSTEM str DESCRIPTION
    Modern, consistent and terse Common Lisp string manipulation library.
    SHA256 06k81x80vjw7qd8gca6lnm5k5ws40c6kl99s7m4z72v7jxwa9ykn URL
    http://beta.quicklisp.org/archive/cl-str/2020-09-25/cl-str-20200925-git.tgz
    MD5 885f94c2be768818ca2fd5e5d562b789 NAME str FILENAME str DEPS
    ((NAME cl-change-case FILENAME cl-change-case)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-unicode FILENAME cl-ppcre-unicode)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES
    (cl-change-case cl-ppcre cl-ppcre-unicode cl-unicode flexi-streams) VERSION
    cl-20200925-git SIBLINGS (str.test) PARASITES NIL) */
