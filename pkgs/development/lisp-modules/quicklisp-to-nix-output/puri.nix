args @ { fetchurl, ... }:
{
  baseName = ''puri'';
  version = ''20180228-git'';

  parasites = [ "puri-tests" ];

  description = ''Portable Universal Resource Indentifier Library'';

  deps = [ args."ptester" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/puri/2018-02-28/puri-20180228-git.tgz'';
    sha256 = ''1s4r5adrjy5asry45xbcbklxhdjydvf6n55z897nvyw33bigrnbz'';
  };

  packageName = "puri";

  asdFilesToKeep = ["puri.asd"];
  overrides = x: x;
}
/* (SYSTEM puri DESCRIPTION Portable Universal Resource Indentifier Library
    SHA256 1s4r5adrjy5asry45xbcbklxhdjydvf6n55z897nvyw33bigrnbz URL
    http://beta.quicklisp.org/archive/puri/2018-02-28/puri-20180228-git.tgz MD5
    0c43ad5d862ed0d18ef84d8e2a42f67f NAME puri FILENAME puri DEPS
    ((NAME ptester FILENAME ptester)) DEPENDENCIES (ptester) VERSION
    20180228-git SIBLINGS NIL PARASITES (puri-tests)) */
