args @ { fetchurl, ... }:
rec {
  baseName = ''str'';
  version = ''cl-20191227-git'';

  description = ''Modern, consistent and terse Common Lisp string manipulation library.'';

  deps = [ args."cl-change-case" args."cl-ppcre" args."cl-ppcre-unicode" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-str/2019-12-27/cl-str-20191227-git.tgz'';
    sha256 = ''0dakksvrd6s96szwhwd89i0hy9mjff2vck30bdnvb6prkwg2c2g6'';
  };

  packageName = "str";

  asdFilesToKeep = ["str.asd"];
  overrides = x: x;
}
/* (SYSTEM str DESCRIPTION
    Modern, consistent and terse Common Lisp string manipulation library.
    SHA256 0dakksvrd6s96szwhwd89i0hy9mjff2vck30bdnvb6prkwg2c2g6 URL
    http://beta.quicklisp.org/archive/cl-str/2019-12-27/cl-str-20191227-git.tgz
    MD5 b2800b32209061b274432c7e699d92b4 NAME str FILENAME str DEPS
    ((NAME cl-change-case FILENAME cl-change-case)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-unicode FILENAME cl-ppcre-unicode)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES
    (cl-change-case cl-ppcre cl-ppcre-unicode cl-unicode flexi-streams) VERSION
    cl-20191227-git SIBLINGS (str.test) PARASITES NIL) */
