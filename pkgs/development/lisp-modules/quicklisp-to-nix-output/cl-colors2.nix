args @ { fetchurl, ... }:
rec {
  baseName = ''cl-colors2'';
  version = ''20200218-git'';

  parasites = [ "cl-colors2/tests" ];

  description = ''Simple color library for Common Lisp'';

  deps = [ args."alexandria" args."cl-ppcre" args."clunit2" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-colors2/2020-02-18/cl-colors2-20200218-git.tgz'';
    sha256 = ''0rpf8j232qv254zhkvkz3ja20al1kswvcqhvvv0r2ag6dks56j29'';
  };

  packageName = "cl-colors2";

  asdFilesToKeep = ["cl-colors2.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-colors2 DESCRIPTION Simple color library for Common Lisp SHA256
    0rpf8j232qv254zhkvkz3ja20al1kswvcqhvvv0r2ag6dks56j29 URL
    http://beta.quicklisp.org/archive/cl-colors2/2020-02-18/cl-colors2-20200218-git.tgz
    MD5 054283564f17af46a09e259ff509b656 NAME cl-colors2 FILENAME cl-colors2
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME clunit2 FILENAME clunit2))
    DEPENDENCIES (alexandria cl-ppcre clunit2) VERSION 20200218-git SIBLINGS
    NIL PARASITES (cl-colors2/tests)) */
