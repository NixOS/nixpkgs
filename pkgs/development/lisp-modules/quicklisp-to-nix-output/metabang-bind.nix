args @ { fetchurl, ... }:
rec {
  baseName = ''metabang-bind'';
  version = ''20191130-git'';

  description = ''Bind is a macro that generalizes multiple-value-bind, let, let*, destructuring-bind, structure and slot accessors, and a whole lot more.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/metabang-bind/2019-11-30/metabang-bind-20191130-git.tgz'';
    sha256 = ''0w4hk94wpfxxznl2xvasnwla7v9i8hrixa1b0r5ngph3n0hq48ci'';
  };

  packageName = "metabang-bind";

  asdFilesToKeep = ["metabang-bind.asd"];
  overrides = x: x;
}
/* (SYSTEM metabang-bind DESCRIPTION
    Bind is a macro that generalizes multiple-value-bind, let, let*, destructuring-bind, structure and slot accessors, and a whole lot more.
    SHA256 0w4hk94wpfxxznl2xvasnwla7v9i8hrixa1b0r5ngph3n0hq48ci URL
    http://beta.quicklisp.org/archive/metabang-bind/2019-11-30/metabang-bind-20191130-git.tgz
    MD5 b0845abb1eadb83e33e91c8d4ad88d2f NAME metabang-bind FILENAME
    metabang-bind DEPS NIL DEPENDENCIES NIL VERSION 20191130-git SIBLINGS
    (metabang-bind-test) PARASITES NIL) */
