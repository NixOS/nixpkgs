args @ { fetchurl, ... }:
{
  baseName = ''cl-mysql'';
  version = ''20171019-git'';

  description = ''Common Lisp MySQL library bindings'';

  deps = [ args."alexandria" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-mysql/2017-10-19/cl-mysql-20171019-git.tgz'';
    sha256 = ''1ga44gkwg6lm225gqpacpqpr6bpswszmw1ba9jhvjpjm09zinyc5'';
  };

  packageName = "cl-mysql";

  asdFilesToKeep = ["cl-mysql.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-mysql DESCRIPTION Common Lisp MySQL library bindings SHA256
    1ga44gkwg6lm225gqpacpqpr6bpswszmw1ba9jhvjpjm09zinyc5 URL
    http://beta.quicklisp.org/archive/cl-mysql/2017-10-19/cl-mysql-20171019-git.tgz
    MD5 e1021da4d35cbb584d4df4f0d7e2bbb9 NAME cl-mysql FILENAME cl-mysql DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi trivial-features) VERSION 20171019-git
    SIBLINGS (cl-mysql-test) PARASITES NIL) */
