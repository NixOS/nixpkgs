args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fuse-meta-fs'';
  version = ''20150608-git'';

  description = ''CFFI bindings to FUSE (Filesystem in user space)'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-fuse" args."cl-utilities" args."iterate" args."pcall" args."pcall-queue" args."trivial-backtrace" args."trivial-features" args."trivial-utf-8" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fuse-meta-fs/2015-06-08/cl-fuse-meta-fs-20150608-git.tgz'';
    sha256 = ''1i3yw237ygwlkhbcbm9q54ad9g4fi63fw4mg508hr7bz9gzg36q2'';
  };

  packageName = "cl-fuse-meta-fs";

  asdFilesToKeep = ["cl-fuse-meta-fs.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fuse-meta-fs DESCRIPTION
    CFFI bindings to FUSE (Filesystem in user space) SHA256
    1i3yw237ygwlkhbcbm9q54ad9g4fi63fw4mg508hr7bz9gzg36q2 URL
    http://beta.quicklisp.org/archive/cl-fuse-meta-fs/2015-06-08/cl-fuse-meta-fs-20150608-git.tgz
    MD5 eb80b959dd6494cd787cff4f8c2f214b NAME cl-fuse-meta-fs FILENAME
    cl-fuse-meta-fs DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME cl-fuse FILENAME cl-fuse) (NAME cl-utilities FILENAME cl-utilities)
     (NAME iterate FILENAME iterate) (NAME pcall FILENAME pcall)
     (NAME pcall-queue FILENAME pcall-queue)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-utf-8 FILENAME trivial-utf-8))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cffi-grovel cffi-toolchain cl-fuse
     cl-utilities iterate pcall pcall-queue trivial-backtrace trivial-features
     trivial-utf-8)
    VERSION 20150608-git SIBLINGS NIL PARASITES NIL) */
