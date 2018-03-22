args @ { fetchurl, ... }:
rec {
  baseName = ''cl-interpol'';
  version = ''20171227-git'';

  parasites = [ "cl-interpol-test" ];

  description = '''';

  deps = [ args."cl-ppcre" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-interpol/2017-12-27/cl-interpol-20171227-git.tgz'';
    sha256 = ''1m4vxw8hskgqi0mnkm7qknwbnri2m69ab7qyd4kbpm2igsi02kzy'';
  };

  packageName = "cl-interpol";

  asdFilesToKeep = ["cl-interpol.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-interpol DESCRIPTION NIL SHA256
    1m4vxw8hskgqi0mnkm7qknwbnri2m69ab7qyd4kbpm2igsi02kzy URL
    http://beta.quicklisp.org/archive/cl-interpol/2017-12-27/cl-interpol-20171227-git.tgz
    MD5 e9d2f0238bb8f7a0c5b1ef1e6ef390ae NAME cl-interpol FILENAME cl-interpol
    DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre cl-unicode flexi-streams) VERSION 20171227-git
    SIBLINGS NIL PARASITES (cl-interpol-test)) */
