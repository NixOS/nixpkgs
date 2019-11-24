args @ { fetchurl, ... }:
rec {
  baseName = ''dbus'';
  version = ''20190521-git'';

  description = ''A D-BUS client library for Common Lisp'';

  deps = [ args."alexandria" args."asdf-package-system" args."babel" args."cl-xmlspam" args."flexi-streams" args."ieee-floats" args."iolib" args."ironclad" args."trivial-garbage" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/dbus/2019-05-21/dbus-20190521-git.tgz'';
    sha256 = ''0g4hsygy52rylhi19kxxhv9dbbirl6hdisgqw89whdxb9py6ifqq'';
  };

  packageName = "dbus";

  asdFilesToKeep = ["dbus.asd"];
  overrides = x: x;
}
/* (SYSTEM dbus DESCRIPTION A D-BUS client library for Common Lisp SHA256
    0g4hsygy52rylhi19kxxhv9dbbirl6hdisgqw89whdxb9py6ifqq URL
    http://beta.quicklisp.org/archive/dbus/2019-05-21/dbus-20190521-git.tgz MD5
    59e7ab92086503e4185273ec3f3ba3fc NAME dbus FILENAME dbus DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME asdf-package-system FILENAME asdf-package-system)
     (NAME babel FILENAME babel) (NAME cl-xmlspam FILENAME cl-xmlspam)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME ieee-floats FILENAME ieee-floats) (NAME iolib FILENAME iolib)
     (NAME ironclad FILENAME ironclad)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES
    (alexandria asdf-package-system babel cl-xmlspam flexi-streams ieee-floats
     iolib ironclad trivial-garbage)
    VERSION 20190521-git SIBLINGS NIL PARASITES NIL) */
