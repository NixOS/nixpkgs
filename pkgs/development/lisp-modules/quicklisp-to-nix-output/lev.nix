/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "lev";
  version = "20150505-git";

  description = "libev bindings for Common Lisp";

  deps = [ args."alexandria" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/lev/2015-05-05/lev-20150505-git.tgz";
    sha256 = "0lkkzb221ks4f0qjgh6pr5lyvb4884a87p96ir4m36x411pyk5xl";
  };

  packageName = "lev";

  asdFilesToKeep = ["lev.asd"];
  overrides = x: x;
}
/* (SYSTEM lev DESCRIPTION libev bindings for Common Lisp SHA256
    0lkkzb221ks4f0qjgh6pr5lyvb4884a87p96ir4m36x411pyk5xl URL
    http://beta.quicklisp.org/archive/lev/2015-05-05/lev-20150505-git.tgz MD5
    10f340f7500beb98b5c0d4a9876131fb NAME lev FILENAME lev DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi trivial-features) VERSION 20150505-git
    SIBLINGS NIL PARASITES NIL) */
