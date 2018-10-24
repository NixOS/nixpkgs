args @ { fetchurl, ... }:
rec {
  baseName = ''cl-html-parse'';
  version = ''20161031-git'';

  description = ''HTML Parser'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-html-parse/2016-10-31/cl-html-parse-20161031-git.tgz'';
    sha256 = ''0i0nl630p9l6rqylydhfqrlqhl5sfq94a9wglx0dajk8gkkqjbnb'';
  };

  packageName = "cl-html-parse";

  asdFilesToKeep = ["cl-html-parse.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-html-parse DESCRIPTION HTML Parser SHA256
    0i0nl630p9l6rqylydhfqrlqhl5sfq94a9wglx0dajk8gkkqjbnb URL
    http://beta.quicklisp.org/archive/cl-html-parse/2016-10-31/cl-html-parse-20161031-git.tgz
    MD5 7fe933c461eaf2dd442da189d6827a72 NAME cl-html-parse FILENAME
    cl-html-parse DEPS NIL DEPENDENCIES NIL VERSION 20161031-git SIBLINGS NIL
    PARASITES NIL) */
