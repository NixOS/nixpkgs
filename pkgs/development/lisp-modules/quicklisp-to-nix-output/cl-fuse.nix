args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fuse'';
  version = ''20160318-git'';

  description = ''CFFI bindings to FUSE (Filesystem in user space)'';

  deps = [ args."cffi" args."cl-utilities" args."bordeaux-threads" args."trivial-backtrace" args."iterate" args."trivial-utf-8" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fuse/2016-03-18/cl-fuse-20160318-git.tgz'';
    sha256 = ''1yllmnnhqp42s37a2y7h7vph854xgna62l1pidvlyskc90bl5jf6'';
  };
}
