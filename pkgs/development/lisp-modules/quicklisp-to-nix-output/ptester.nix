args @ { fetchurl, ... }:
rec {
  baseName = ''ptester'';
  version = ''20160929-git'';

  description = ''Portable test harness package'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/ptester/2016-09-29/ptester-20160929-git.tgz'';
    sha256 = ''04rlq1zljhxc65pm31bah3sq3as24l0sdivz440s79qlnnyh13hz'';
  };

  packageName = "ptester";

  asdFilesToKeep = ["ptester.asd"];
  overrides = x: x;
}
/* (SYSTEM ptester DESCRIPTION Portable test harness package SHA256
    04rlq1zljhxc65pm31bah3sq3as24l0sdivz440s79qlnnyh13hz URL
    http://beta.quicklisp.org/archive/ptester/2016-09-29/ptester-20160929-git.tgz
    MD5 938a4366b6608ae5c4a0be9da11a61d4 NAME ptester FILENAME ptester DEPS NIL
    DEPENDENCIES NIL VERSION 20160929-git SIBLINGS NIL PARASITES NIL) */
