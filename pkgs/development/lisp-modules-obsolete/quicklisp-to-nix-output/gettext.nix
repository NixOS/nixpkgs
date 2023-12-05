/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "gettext";
  version = "20171130-git";

  description = "An pure Common Lisp implementation of gettext runtime. gettext is an internationalization and localization (i18n) system commonly used for writing multilingual programs on Unix-like computer operating systems.";

  deps = [ args."flexi-streams" args."split-sequence" args."trivial-gray-streams" args."yacc" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/gettext/2017-11-30/gettext-20171130-git.tgz";
    sha256 = "0nb8i66sb5qmpnk6rk2adlr87m322bra0xpirp63872mybd3y6yd";
  };

  packageName = "gettext";

  asdFilesToKeep = ["gettext.asd"];
  overrides = x: x;
}
/* (SYSTEM gettext DESCRIPTION
    An pure Common Lisp implementation of gettext runtime. gettext is an internationalization and localization (i18n) system commonly used for writing multilingual programs on Unix-like computer operating systems.
    SHA256 0nb8i66sb5qmpnk6rk2adlr87m322bra0xpirp63872mybd3y6yd URL
    http://beta.quicklisp.org/archive/gettext/2017-11-30/gettext-20171130-git.tgz
    MD5 d162cb5310db5011c82ef6343fd280ed NAME gettext FILENAME gettext DEPS
    ((NAME flexi-streams FILENAME flexi-streams)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME yacc FILENAME yacc))
    DEPENDENCIES (flexi-streams split-sequence trivial-gray-streams yacc)
    VERSION 20171130-git SIBLINGS (gettext-example gettext-tests) PARASITES NIL) */
