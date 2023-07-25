/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "dbus";
  version = "20211020-git";

  description = "A D-BUS client library for Common Lisp";

  deps = [ args."alexandria" args."asdf-package-system" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-ppcre" args."cl-xmlspam" args."closure-common" args."cxml" args."flexi-streams" args."idna" args."ieee-floats" args."iolib" args."iolib_dot_asdf" args."iolib_dot_base" args."iolib_dot_common-lisp" args."iolib_dot_conf" args."ironclad" args."puri" args."split-sequence" args."swap-bytes" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/dbus/2021-10-20/dbus-20211020-git.tgz";
    sha256 = "1h0qa609qplq3grjf3n31h1bcdj154ww2dn29mjxlkm76n5asz14";
  };

  packageName = "dbus";

  asdFilesToKeep = ["dbus.asd"];
  overrides = x: x;
}
/* (SYSTEM dbus DESCRIPTION A D-BUS client library for Common Lisp SHA256
    1h0qa609qplq3grjf3n31h1bcdj154ww2dn29mjxlkm76n5asz14 URL
    http://beta.quicklisp.org/archive/dbus/2021-10-20/dbus-20211020-git.tgz MD5
    f3fb2ad37c197d99d9c446f556a12bdb NAME dbus FILENAME dbus DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME asdf-package-system FILENAME asdf-package-system)
     (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-xmlspam FILENAME cl-xmlspam)
     (NAME closure-common FILENAME closure-common) (NAME cxml FILENAME cxml)
     (NAME flexi-streams FILENAME flexi-streams) (NAME idna FILENAME idna)
     (NAME ieee-floats FILENAME ieee-floats) (NAME iolib FILENAME iolib)
     (NAME iolib.asdf FILENAME iolib_dot_asdf)
     (NAME iolib.base FILENAME iolib_dot_base)
     (NAME iolib.common-lisp FILENAME iolib_dot_common-lisp)
     (NAME iolib.conf FILENAME iolib_dot_conf)
     (NAME ironclad FILENAME ironclad) (NAME puri FILENAME puri)
     (NAME split-sequence FILENAME split-sequence)
     (NAME swap-bytes FILENAME swap-bytes)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria asdf-package-system babel bordeaux-threads cffi cffi-grovel
     cffi-toolchain cl-ppcre cl-xmlspam closure-common cxml flexi-streams idna
     ieee-floats iolib iolib.asdf iolib.base iolib.common-lisp iolib.conf
     ironclad puri split-sequence swap-bytes trivial-features trivial-garbage
     trivial-gray-streams)
    VERSION 20211020-git SIBLINGS NIL PARASITES NIL) */
