/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "quri";
  version = "20210228-git";

  description = "Yet another URI library for Common Lisp";

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/quri/2021-02-28/quri-20210228-git.tgz";
    sha256 = "03hq6x715kv37c089b73f6j8b0f4ywhxr37wbw9any2jcgrswx0g";
  };

  packageName = "quri";

  asdFilesToKeep = ["quri.asd"];
  overrides = x: x;
}
/* (SYSTEM quri DESCRIPTION Yet another URI library for Common Lisp SHA256
    03hq6x715kv37c089b73f6j8b0f4ywhxr37wbw9any2jcgrswx0g URL
    http://beta.quicklisp.org/archive/quri/2021-02-28/quri-20210228-git.tgz MD5
    67eac028850cc2539c076d31b049f7bd NAME quri FILENAME quri DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-utilities split-sequence trivial-features) VERSION
    20210228-git SIBLINGS (quri-test) PARASITES NIL) */
