args @ { fetchurl, ... }:
rec {
  baseName = ''puri'';
  version = ''20150923-git'';

  description = ''Portable Universal Resource Indentifier Library'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/puri/2015-09-23/puri-20150923-git.tgz'';
    sha256 = ''099ay2zji5ablj2jj56sb49hk2l9x5s11vpx6893qwwjsp2881qa'';
  };

  overrides = x: {
  };
}
