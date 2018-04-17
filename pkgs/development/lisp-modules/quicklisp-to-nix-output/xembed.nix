args @ { fetchurl, ... }:
rec {
  baseName = ''xembed'';
  version = ''clx-20120909-git'';

  description = '''';

  deps = [ args."clx" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx-xembed/2012-09-09/clx-xembed-20120909-git.tgz'';
    sha256 = ''06h2md0lb0sribpkg5k7z7fnc02k0ssaswcimg2ya8wqypj4rlbb'';
  };

  packageName = "xembed";

  asdFilesToKeep = ["xembed.asd"];
  overrides = x: x;
}
/* (SYSTEM xembed DESCRIPTION NIL SHA256
    06h2md0lb0sribpkg5k7z7fnc02k0ssaswcimg2ya8wqypj4rlbb URL
    http://beta.quicklisp.org/archive/clx-xembed/2012-09-09/clx-xembed-20120909-git.tgz
    MD5 4270362697093017ac0243b71e3576f9 NAME xembed FILENAME xembed DEPS
    ((NAME clx FILENAME clx)) DEPENDENCIES (clx) VERSION clx-20120909-git
    SIBLINGS NIL PARASITES NIL) */
