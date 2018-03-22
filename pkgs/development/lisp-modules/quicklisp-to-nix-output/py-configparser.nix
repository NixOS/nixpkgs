args @ { fetchurl, ... }:
rec {
  baseName = ''py-configparser'';
  version = ''20170830-svn'';

  description = ''Common Lisp implementation of the Python ConfigParser module'';

  deps = [ args."parse-number" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/py-configparser/2017-08-30/py-configparser-20170830-svn.tgz'';
    sha256 = ''0lf062m6nrq61cxafi7jyfh3ianml1qqqzdfd5pm1wzakl2jqp9j'';
  };

  packageName = "py-configparser";

  asdFilesToKeep = ["py-configparser.asd"];
  overrides = x: x;
}
/* (SYSTEM py-configparser DESCRIPTION
    Common Lisp implementation of the Python ConfigParser module SHA256
    0lf062m6nrq61cxafi7jyfh3ianml1qqqzdfd5pm1wzakl2jqp9j URL
    http://beta.quicklisp.org/archive/py-configparser/2017-08-30/py-configparser-20170830-svn.tgz
    MD5 b6a9fc2a9c70760d6683cafe656f9e90 NAME py-configparser FILENAME
    py-configparser DEPS ((NAME parse-number FILENAME parse-number))
    DEPENDENCIES (parse-number) VERSION 20170830-svn SIBLINGS NIL PARASITES NIL) */
