args @ { fetchurl, ... }:
rec {
  baseName = ''quri'';
  version = ''20191130-git'';

  description = ''Yet another URI library for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/quri/2019-11-30/quri-20191130-git.tgz'';
    sha256 = ''00j71xf4c81w4lby22w2nm508djj36z4v4g3k5qsw16ylf92pkbs'';
  };

  packageName = "quri";

  asdFilesToKeep = ["quri.asd"];
  overrides = x: x;
}
/* (SYSTEM quri DESCRIPTION Yet another URI library for Common Lisp SHA256
    00j71xf4c81w4lby22w2nm508djj36z4v4g3k5qsw16ylf92pkbs URL
    http://beta.quicklisp.org/archive/quri/2019-11-30/quri-20191130-git.tgz MD5
    4a3e8d2ebe459ea731738650c2c5bf56 NAME quri FILENAME quri DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-utilities split-sequence trivial-features) VERSION
    20191130-git SIBLINGS (quri-test) PARASITES NIL) */
