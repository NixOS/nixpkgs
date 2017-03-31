args @ { fetchurl, ... }:
rec {
  baseName = ''lev'';
  version = ''20150505-git'';

  description = ''libev bindings for Common Lisp'';

  deps = [ args."cffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lev/2015-05-05/lev-20150505-git.tgz'';
    sha256 = ''0lkkzb221ks4f0qjgh6pr5lyvb4884a87p96ir4m36x411pyk5xl'';
  };

  overrides = x: {
  };
}
