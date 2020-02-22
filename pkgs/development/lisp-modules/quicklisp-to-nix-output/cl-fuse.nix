args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fuse'';
  version = ''20190710-git'';

  description = ''CFFI bindings to FUSE (Filesystem in user space)'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-utilities" args."iterate" args."trivial-backtrace" args."trivial-features" args."trivial-utf-8" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fuse/2019-07-10/cl-fuse-20190710-git.tgz'';
    sha256 = ''1gxah8qwwb9xlvbdy5xxz07hh2hsw7xdrps1n4slhz4x6vyy80li'';
  };

  packageName = "cl-fuse";

  asdFilesToKeep = ["cl-fuse.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fuse DESCRIPTION CFFI bindings to FUSE (Filesystem in user space)
    SHA256 1gxah8qwwb9xlvbdy5xxz07hh2hsw7xdrps1n4slhz4x6vyy80li URL
    http://beta.quicklisp.org/archive/cl-fuse/2019-07-10/cl-fuse-20190710-git.tgz
    MD5 5f267e59eb2358b1b6e4e735fb408e6a NAME cl-fuse FILENAME cl-fuse DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME cl-utilities FILENAME cl-utilities) (NAME iterate FILENAME iterate)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-utf-8 FILENAME trivial-utf-8))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cffi-grovel cffi-toolchain
     cl-utilities iterate trivial-backtrace trivial-features trivial-utf-8)
    VERSION 20190710-git SIBLINGS NIL PARASITES NIL) */
