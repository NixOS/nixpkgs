args @ { fetchurl, ... }:
rec {
  baseName = ''cl-who'';
  version = ''20171130-git'';

  parasites = [ "cl-who-test" ];

  description = ''(X)HTML generation macros'';

  deps = [ args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-who/2017-11-30/cl-who-20171130-git.tgz'';
    sha256 = ''1941kwnvqnqr81vjkv8fcpc16abz7hrrmz18xwxxprsi6wifzjzw'';
  };

  packageName = "cl-who";

  asdFilesToKeep = ["cl-who.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-who DESCRIPTION (X)HTML generation macros SHA256
    1941kwnvqnqr81vjkv8fcpc16abz7hrrmz18xwxxprsi6wifzjzw URL
    http://beta.quicklisp.org/archive/cl-who/2017-11-30/cl-who-20171130-git.tgz
    MD5 257a670166ff9d24d1570f44be0c7171 NAME cl-who FILENAME cl-who DEPS
    ((NAME flexi-streams FILENAME flexi-streams)) DEPENDENCIES (flexi-streams)
    VERSION 20171130-git SIBLINGS NIL PARASITES (cl-who-test)) */
