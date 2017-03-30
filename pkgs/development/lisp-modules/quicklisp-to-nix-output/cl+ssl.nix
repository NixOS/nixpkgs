args @ { fetchurl, ... }:
rec {
  baseName = ''cl+ssl'';
  version = ''cl+ssl-20161208-git'';

  description = ''Common Lisp interface to OpenSSL.'';

  deps = [ args."cffi" args."trivial-gray-streams" args."flexi-streams" args."bordeaux-threads" args."trivial-garbage" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl+ssl/2016-12-08/cl+ssl-20161208-git.tgz'';
    sha256 = ''0x9xa2rdfh9gxp5m27cj0wvzjqccz4w5cvm7nbk5shwsz5xgr7hs'';
  };
}
