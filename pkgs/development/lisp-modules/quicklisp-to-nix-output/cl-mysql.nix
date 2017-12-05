args @ { fetchurl, ... }:
rec {
  baseName = ''cl-mysql'';
  version = ''20160628-git'';

  description = ''Common Lisp MySQL library bindings'';

  deps = [ args."alexandria" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-mysql/2016-06-28/cl-mysql-20160628-git.tgz'';
    sha256 = ''1zkijanw34nc91dn9jv30590ir6jw7bbcwjsqbvli69fh4b03319'';
  };

  packageName = "cl-mysql";

  asdFilesToKeep = ["cl-mysql.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-mysql DESCRIPTION Common Lisp MySQL library bindings SHA256
    1zkijanw34nc91dn9jv30590ir6jw7bbcwjsqbvli69fh4b03319 URL
    http://beta.quicklisp.org/archive/cl-mysql/2016-06-28/cl-mysql-20160628-git.tgz
    MD5 349615d041c2f2177b678088f9c22409 NAME cl-mysql FILENAME cl-mysql DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi trivial-features) VERSION 20160628-git
    SIBLINGS (cl-mysql-test) PARASITES NIL) */
