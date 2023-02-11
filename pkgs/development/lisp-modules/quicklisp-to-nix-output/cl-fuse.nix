/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-fuse";
  version = "20200925-git";

  description = "CFFI bindings to FUSE (Filesystem in user space)";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-utilities" args."iterate" args."trivial-backtrace" args."trivial-features" args."trivial-utf-8" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-fuse/2020-09-25/cl-fuse-20200925-git.tgz";
    sha256 = "1c5cn0l0md77asw804qssylcbbphw81mfpbijydd0s25q6xga7dp";
  };

  packageName = "cl-fuse";

  asdFilesToKeep = ["cl-fuse.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-fuse DESCRIPTION CFFI bindings to FUSE (Filesystem in user space)
    SHA256 1c5cn0l0md77asw804qssylcbbphw81mfpbijydd0s25q6xga7dp URL
    http://beta.quicklisp.org/archive/cl-fuse/2020-09-25/cl-fuse-20200925-git.tgz
    MD5 0342ea914801f40d804629170a435e54 NAME cl-fuse FILENAME cl-fuse DEPS
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
    VERSION 20200925-git SIBLINGS NIL PARASITES NIL) */
