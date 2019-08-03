args @ { fetchurl, ... }:
rec {
  baseName = ''quri'';
  version = ''20181210-git'';

  description = ''Yet another URI library for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/quri/2018-12-10/quri-20181210-git.tgz'';
    sha256 = ''0iy2q1jg1j07sw5al6c325zkwcbs218z3dszd785vl89ms6kjyn4'';
  };

  packageName = "quri";

  asdFilesToKeep = ["quri.asd"];
  overrides = x: x;
}
/* (SYSTEM quri DESCRIPTION Yet another URI library for Common Lisp SHA256
    0iy2q1jg1j07sw5al6c325zkwcbs218z3dszd785vl89ms6kjyn4 URL
    http://beta.quicklisp.org/archive/quri/2018-12-10/quri-20181210-git.tgz MD5
    94f607540ccc8a15a4439527e41bf7ac NAME quri FILENAME quri DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-utilities split-sequence trivial-features) VERSION
    20181210-git SIBLINGS (quri-test) PARASITES NIL) */
