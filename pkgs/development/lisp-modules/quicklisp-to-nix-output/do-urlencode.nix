args @ { fetchurl, ... }:
rec {
  baseName = ''do-urlencode'';
  version = ''20170830-git'';

  description = ''Percent Encoding (aka URL Encoding) library'';

  deps = [ args."alexandria" args."babel" args."babel-streams" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/do-urlencode/2017-08-30/do-urlencode-20170830-git.tgz'';
    sha256 = ''1584prmmz601fp396qxrivylb7nrnclg9rnwrsnwiij79v6zz40n'';
  };

  packageName = "do-urlencode";

  asdFilesToKeep = ["do-urlencode.asd"];
  overrides = x: x;
}
/* (SYSTEM do-urlencode DESCRIPTION Percent Encoding (aka URL Encoding) library
    SHA256 1584prmmz601fp396qxrivylb7nrnclg9rnwrsnwiij79v6zz40n URL
    http://beta.quicklisp.org/archive/do-urlencode/2017-08-30/do-urlencode-20170830-git.tgz
    MD5 071a18bb58ed5c7d5184b34e672b5d91 NAME do-urlencode FILENAME
    do-urlencode DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME babel-streams FILENAME babel-streams)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel babel-streams trivial-features trivial-gray-streams)
    VERSION 20170830-git SIBLINGS NIL PARASITES NIL) */
