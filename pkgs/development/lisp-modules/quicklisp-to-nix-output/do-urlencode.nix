args @ { fetchurl, ... }:
rec {
  baseName = ''do-urlencode'';
  version = ''20130720-git'';

  description = ''Percent Encoding (aka URL Encoding) library'';

  deps = [ args."alexandria" args."babel" args."babel-streams" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/do-urlencode/2013-07-20/do-urlencode-20130720-git.tgz'';
    sha256 = ''19l4rwqc52w7nrpy994b3n2dcv8pjgc530yn2xmgqlqabpxpz3xa'';
  };

  packageName = "do-urlencode";

  asdFilesToKeep = ["do-urlencode.asd"];
  overrides = x: x;
}
/* (SYSTEM do-urlencode DESCRIPTION Percent Encoding (aka URL Encoding) library
    SHA256 19l4rwqc52w7nrpy994b3n2dcv8pjgc530yn2xmgqlqabpxpz3xa URL
    http://beta.quicklisp.org/archive/do-urlencode/2013-07-20/do-urlencode-20130720-git.tgz
    MD5 c8085e138711c225042acf83b4bf0507 NAME do-urlencode FILENAME
    do-urlencode DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME babel-streams FILENAME babel-streams)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel babel-streams trivial-features trivial-gray-streams)
    VERSION 20130720-git SIBLINGS NIL PARASITES NIL) */
