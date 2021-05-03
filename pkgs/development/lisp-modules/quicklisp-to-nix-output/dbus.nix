/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "dbus";
  version = "20200610-git";

  description = "A D-BUS client library for Common Lisp";

  deps = [ args."alexandria" args."asdf-package-system" args."babel" args."cl-xmlspam" args."flexi-streams" args."ieee-floats" args."iolib" args."ironclad" args."trivial-garbage" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/dbus/2020-06-10/dbus-20200610-git.tgz";
    sha256 = "1njwjf1z9xngsfmlddmbcan49vcjqvvxfkhbi62xcxwbn9rgqn79";
  };

  packageName = "dbus";

  asdFilesToKeep = ["dbus.asd"];
  overrides = x: x;
}
/* (SYSTEM dbus DESCRIPTION A D-BUS client library for Common Lisp SHA256
    1njwjf1z9xngsfmlddmbcan49vcjqvvxfkhbi62xcxwbn9rgqn79 URL
    http://beta.quicklisp.org/archive/dbus/2020-06-10/dbus-20200610-git.tgz MD5
    421fb481812b2da62fa5ee424f607b12 NAME dbus FILENAME dbus DEPS
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
    VERSION 20200610-git SIBLINGS NIL PARASITES NIL) */
