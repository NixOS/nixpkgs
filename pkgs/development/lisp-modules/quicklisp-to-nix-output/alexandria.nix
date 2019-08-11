args @ { fetchurl, ... }:
rec {
  baseName = ''alexandria'';
  version = ''20181210-git'';

  description = ''Alexandria is a collection of portable public domain utilities.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/alexandria/2018-12-10/alexandria-20181210-git.tgz'';
    sha256 = ''0dg0gr7cgrrl70sq0sbz8i1zcli54bqg4x532wscz3156xrl2588'';
  };

  packageName = "alexandria";

  asdFilesToKeep = ["alexandria.asd"];
  overrides = x: x;
}
/* (SYSTEM alexandria DESCRIPTION
    Alexandria is a collection of portable public domain utilities. SHA256
    0dg0gr7cgrrl70sq0sbz8i1zcli54bqg4x532wscz3156xrl2588 URL
    http://beta.quicklisp.org/archive/alexandria/2018-12-10/alexandria-20181210-git.tgz
    MD5 2a7530a412cd94a56b6d4e5864fb8819 NAME alexandria FILENAME alexandria
    DEPS NIL DEPENDENCIES NIL VERSION 20181210-git SIBLINGS (alexandria-tests)
    PARASITES NIL) */
