args @ { fetchurl, ... }:
{
  baseName = ''iolib_dot_common-lisp'';
  version = ''iolib-v0.8.3'';

  description = ''Slightly modified Common Lisp.'';

  deps = [ args."alexandria" args."iolib_dot_asdf" args."iolib_dot_conf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz'';
    sha256 = ''12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c'';
  };

  packageName = "iolib.common-lisp";

  asdFilesToKeep = ["iolib.common-lisp.asd"];
  overrides = x: x;
}
/* (SYSTEM iolib.common-lisp DESCRIPTION Slightly modified Common Lisp. SHA256
    12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c URL
    http://beta.quicklisp.org/archive/iolib/2018-02-28/iolib-v0.8.3.tgz MD5
    fc28d4cad6f8e43972df3baa6a8ac45c NAME iolib.common-lisp FILENAME
    iolib_dot_common-lisp DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME iolib.asdf FILENAME iolib_dot_asdf)
     (NAME iolib.conf FILENAME iolib_dot_conf))
    DEPENDENCIES (alexandria iolib.asdf iolib.conf) VERSION iolib-v0.8.3
    SIBLINGS
    (iolib iolib.asdf iolib.base iolib.conf iolib.examples iolib.grovel
     iolib.tests)
    PARASITES NIL) */
