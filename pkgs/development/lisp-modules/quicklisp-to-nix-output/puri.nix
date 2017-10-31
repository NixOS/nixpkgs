args @ { fetchurl, ... }:
rec {
  baseName = ''puri'';
  version = ''20150923-git'';

  parasites = [ "puri-tests" ];

  description = ''Portable Universal Resource Indentifier Library'';

  deps = [ args."ptester" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/puri/2015-09-23/puri-20150923-git.tgz'';
    sha256 = ''099ay2zji5ablj2jj56sb49hk2l9x5s11vpx6893qwwjsp2881qa'';
  };

  packageName = "puri";

  asdFilesToKeep = ["puri.asd"];
  overrides = x: x;
}
/* (SYSTEM puri DESCRIPTION Portable Universal Resource Indentifier Library
    SHA256 099ay2zji5ablj2jj56sb49hk2l9x5s11vpx6893qwwjsp2881qa URL
    http://beta.quicklisp.org/archive/puri/2015-09-23/puri-20150923-git.tgz MD5
    3bd4e30aa6b6baf6f26753b5fc357e0f NAME puri FILENAME puri DEPS
    ((NAME ptester FILENAME ptester)) DEPENDENCIES (ptester) VERSION
    20150923-git SIBLINGS NIL PARASITES (puri-tests)) */
