args @ { fetchurl, ... }:
rec {
  baseName = ''str'';
  version = ''cl-20190710-git'';

  description = ''Modern, consistent and terse Common Lisp string manipulation library.'';

  deps = [ args."cl-ppcre" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-str/2019-07-10/cl-str-20190710-git.tgz'';
    sha256 = ''1mlnrj9g1d7zbpq6c4vhyw0idhvbm55zpzrbc8iiyv0dzijk70l9'';
  };

  packageName = "str";

  asdFilesToKeep = ["str.asd"];
  overrides = x: x;
}
/* (SYSTEM str DESCRIPTION
    Modern, consistent and terse Common Lisp string manipulation library.
    SHA256 1mlnrj9g1d7zbpq6c4vhyw0idhvbm55zpzrbc8iiyv0dzijk70l9 URL
    http://beta.quicklisp.org/archive/cl-str/2019-07-10/cl-str-20190710-git.tgz
    MD5 d3c72394ea33291347d8c825c153c143 NAME str FILENAME str DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)) DEPENDENCIES (cl-ppcre) VERSION
    cl-20190710-git SIBLINGS (str.test) PARASITES NIL) */
