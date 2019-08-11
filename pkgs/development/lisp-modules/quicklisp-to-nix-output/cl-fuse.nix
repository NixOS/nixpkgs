args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fuse'';
  version = ''20160318-git'';

  description = ''CFFI bindings to FUSE (Filesystem in user space)'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-utilities" args."iterate" args."trivial-backtrace" args."trivial-features" args."trivial-utf-8" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fuse/2016-03-18/cl-fuse-20160318-git.tgz'';
    sha256 = ''1yllmnnhqp42s37a2y7h7vph854xgna62l1pidvlyskc90bl5jf6'';
  };

  packageName = "cl-fuse";

  asdFilesToKeep = ["cl-fuse.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fuse DESCRIPTION CFFI bindings to FUSE (Filesystem in user space)
    SHA256 1yllmnnhqp42s37a2y7h7vph854xgna62l1pidvlyskc90bl5jf6 URL
    http://beta.quicklisp.org/archive/cl-fuse/2016-03-18/cl-fuse-20160318-git.tgz
    MD5 ce2e907e5ae2cece72fa314be1ced44c NAME cl-fuse FILENAME cl-fuse DEPS
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
    VERSION 20160318-git SIBLINGS NIL PARASITES NIL) */
