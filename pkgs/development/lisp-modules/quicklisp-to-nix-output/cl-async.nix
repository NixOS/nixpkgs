args @ { fetchurl, ... }:
rec {
  baseName = ''cl-async'';
  version = ''20160825-git'';

  description = ''Asynchronous operations for Common Lisp.'';

  deps = [ args."babel" args."cffi" args."cl-async-base" args."cl-async-util" args."cl-libuv" args."cl-ppcre" args."static-vectors" args."trivial-features" args."trivial-gray-streams" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz'';
    sha256 = ''104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa'';
  };

  overrides = x: {
  };
}
