args @ { fetchurl, ... }:
rec {
  baseName = ''quri'';
  version = ''20200610-git'';

  description = ''Yet another URI library for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/quri/2020-06-10/quri-20200610-git.tgz'';
    sha256 = ''1qv8x1m6m70jczvydfq9ws5zw3jw6y74s607vfrqaf0ck5rrwsk6'';
  };

  packageName = "quri";

  asdFilesToKeep = ["quri.asd"];
  overrides = x: x;
}
/* (SYSTEM quri DESCRIPTION Yet another URI library for Common Lisp SHA256
    1qv8x1m6m70jczvydfq9ws5zw3jw6y74s607vfrqaf0ck5rrwsk6 URL
    http://beta.quicklisp.org/archive/quri/2020-06-10/quri-20200610-git.tgz MD5
    409b559ce780952f1349b2abeaf47235 NAME quri FILENAME quri DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-utilities split-sequence trivial-features) VERSION
    20200610-git SIBLINGS (quri-test) PARASITES NIL) */
