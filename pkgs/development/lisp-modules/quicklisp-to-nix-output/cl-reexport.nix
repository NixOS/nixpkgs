args @ { fetchurl, ... }:
{
  baseName = ''cl-reexport'';
  version = ''20150709-git'';

  description = ''Reexport external symbols in other packages.'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-reexport/2015-07-09/cl-reexport-20150709-git.tgz'';
    sha256 = ''1y6qlyps7g0wl4rbmzvw6s1kjdwwmh33layyjclsjp9j5nm8mdmi'';
  };

  packageName = "cl-reexport";

  asdFilesToKeep = ["cl-reexport.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-reexport DESCRIPTION Reexport external symbols in other packages.
    SHA256 1y6qlyps7g0wl4rbmzvw6s1kjdwwmh33layyjclsjp9j5nm8mdmi URL
    http://beta.quicklisp.org/archive/cl-reexport/2015-07-09/cl-reexport-20150709-git.tgz
    MD5 207d02771cbd906d033ff704ca5c3a3d NAME cl-reexport FILENAME cl-reexport
    DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria)
    VERSION 20150709-git SIBLINGS (cl-reexport-test) PARASITES NIL) */
