args @ { fetchurl, ... }:
rec {
  baseName = ''clx'';
  version = ''20181210-git'';

  parasites = [ "clx/test" ];

  description = ''An implementation of the X Window System protocol in Lisp.'';

  deps = [ args."fiasco" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx/2018-12-10/clx-20181210-git.tgz'';
    sha256 = ''1xaylf5j1xdyqmvpw7c3hdcc44bz8ax4rz02n8hvznwvg3xcman6'';
  };

  packageName = "clx";

  asdFilesToKeep = ["clx.asd"];
  overrides = x: x;
}
/* (SYSTEM clx DESCRIPTION
    An implementation of the X Window System protocol in Lisp. SHA256
    1xaylf5j1xdyqmvpw7c3hdcc44bz8ax4rz02n8hvznwvg3xcman6 URL
    http://beta.quicklisp.org/archive/clx/2018-12-10/clx-20181210-git.tgz MD5
    d6d0edd1594e6bc420b1e2ba0c453636 NAME clx FILENAME clx DEPS
    ((NAME fiasco FILENAME fiasco)) DEPENDENCIES (fiasco) VERSION 20181210-git
    SIBLINGS NIL PARASITES (clx/test)) */
