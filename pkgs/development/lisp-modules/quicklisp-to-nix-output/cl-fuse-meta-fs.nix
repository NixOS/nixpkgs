/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-fuse-meta-fs";
  version = "20190710-git";

  description = "CFFI bindings to FUSE (Filesystem in user space)";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-fuse" args."cl-utilities" args."iterate" args."pcall" args."pcall-queue" args."trivial-backtrace" args."trivial-features" args."trivial-utf-8" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-fuse-meta-fs/2019-07-10/cl-fuse-meta-fs-20190710-git.tgz";
    sha256 = "1c2nyxj7q8njxydn4xiagvnb21zhb1l07q7nhfw0qs2qk6dkasq7";
  };

  packageName = "cl-fuse-meta-fs";

  asdFilesToKeep = ["cl-fuse-meta-fs.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fuse-meta-fs DESCRIPTION
    CFFI bindings to FUSE (Filesystem in user space) SHA256
    1c2nyxj7q8njxydn4xiagvnb21zhb1l07q7nhfw0qs2qk6dkasq7 URL
    http://beta.quicklisp.org/archive/cl-fuse-meta-fs/2019-07-10/cl-fuse-meta-fs-20190710-git.tgz
    MD5 461f7023274fb273e6c759e881bdd636 NAME cl-fuse-meta-fs FILENAME
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
    VERSION 20190710-git SIBLINGS NIL PARASITES NIL) */
