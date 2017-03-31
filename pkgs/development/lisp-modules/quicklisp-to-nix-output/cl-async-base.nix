args @ { fetchurl, ... }:
rec {
  baseName = ''cl-async-base'';
  version = ''cl-async-20160825-git'';

  description = ''Base system for cl-async.'';

  deps = [ args."bordeaux-threads" args."cffi" args."cl-libuv" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz'';
    sha256 = ''104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa'';
  };

  overrides = x: {
  };
}
