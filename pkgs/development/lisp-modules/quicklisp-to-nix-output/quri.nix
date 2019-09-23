args @ { fetchurl, ... }:
{
  baseName = ''quri'';
  version = ''20190521-git'';

  description = ''Yet another URI library for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/quri/2019-05-21/quri-20190521-git.tgz'';
    sha256 = ''1khhdhn1isszii52xaibn6m4hv4sm5j2v0vgc2rp1x05xds9rzs2'';
  };

  packageName = "quri";

  asdFilesToKeep = ["quri.asd"];
  overrides = x: x;
}
/* (SYSTEM quri DESCRIPTION Yet another URI library for Common Lisp SHA256
    1khhdhn1isszii52xaibn6m4hv4sm5j2v0vgc2rp1x05xds9rzs2 URL
    http://beta.quicklisp.org/archive/quri/2019-05-21/quri-20190521-git.tgz MD5
    c2e37013c3b8e109aeb009719e9492ac NAME quri FILENAME quri DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-utilities split-sequence trivial-features) VERSION
    20190521-git SIBLINGS (quri-test) PARASITES NIL) */
