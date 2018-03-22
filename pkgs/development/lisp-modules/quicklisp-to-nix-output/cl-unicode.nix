args @ { fetchurl, ... }:
rec {
  baseName = ''cl-unicode'';
  version = ''20180131-git'';

  parasites = [ "cl-unicode/base" "cl-unicode/build" "cl-unicode/test" ];

  description = ''Portable Unicode Library'';

  deps = [ args."cl-ppcre" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unicode/2018-01-31/cl-unicode-20180131-git.tgz'';
    sha256 = ''113hsx22pw4ydwzkyr9y7l8a8jq3nkhwazs03wj3mh2dczwv28xa'';
  };

  packageName = "cl-unicode";

  asdFilesToKeep = ["cl-unicode.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-unicode DESCRIPTION Portable Unicode Library SHA256
    113hsx22pw4ydwzkyr9y7l8a8jq3nkhwazs03wj3mh2dczwv28xa URL
    http://beta.quicklisp.org/archive/cl-unicode/2018-01-31/cl-unicode-20180131-git.tgz
    MD5 653ba12d595599b32aa2a8c7c8b65c28 NAME cl-unicode FILENAME cl-unicode
    DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre flexi-streams) VERSION 20180131-git SIBLINGS NIL
    PARASITES (cl-unicode/base cl-unicode/build cl-unicode/test)) */
