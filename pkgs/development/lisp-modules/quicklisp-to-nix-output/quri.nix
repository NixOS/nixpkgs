args @ { fetchurl, ... }:
rec {
  baseName = ''quri'';
  version = ''20161204-git'';

  description = ''Yet another URI library for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/quri/2016-12-04/quri-20161204-git.tgz'';
    sha256 = ''14if83kd2mv68p4g4ch2w796w3micpzv40z7xrcwzwj64wngwabv'';
  };

  packageName = "quri";

  asdFilesToKeep = ["quri.asd"];
  overrides = x: x;
}
/* (SYSTEM quri DESCRIPTION Yet another URI library for Common Lisp SHA256
    14if83kd2mv68p4g4ch2w796w3micpzv40z7xrcwzwj64wngwabv URL
    http://beta.quicklisp.org/archive/quri/2016-12-04/quri-20161204-git.tgz MD5
    8c87e99d4f7308d83aab361a6e36508a NAME quri FILENAME quri DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-utilities split-sequence trivial-features) VERSION
    20161204-git SIBLINGS (quri-test) PARASITES NIL) */
