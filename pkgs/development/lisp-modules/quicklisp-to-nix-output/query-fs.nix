args @ { fetchurl, ... }:
rec {
  baseName = ''query-fs'';
  version = ''20190107-git'';

  description = ''High-level virtual FS using CL-Fuse-Meta-FS to represent results of queries'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-fuse" args."cl-fuse-meta-fs" args."cl-ppcre" args."cl-utilities" args."command-line-arguments" args."iterate" args."pcall" args."pcall-queue" args."trivial-backtrace" args."trivial-features" args."trivial-utf-8" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/query-fs/2019-01-07/query-fs-20190107-git.tgz'';
    sha256 = ''1980k3l970ma1571myr66nxaxkg2vzf81a2wn28qcx40niy6pbq4'';
  };

  packageName = "query-fs";

  asdFilesToKeep = ["query-fs.asd"];
  overrides = x: x;
}
/* (SYSTEM query-fs DESCRIPTION
    High-level virtual FS using CL-Fuse-Meta-FS to represent results of queries
    SHA256 1980k3l970ma1571myr66nxaxkg2vzf81a2wn28qcx40niy6pbq4 URL
    http://beta.quicklisp.org/archive/query-fs/2019-01-07/query-fs-20190107-git.tgz
    MD5 3abd1f0a2f82d10d919bb5b4aa5485be NAME query-fs FILENAME query-fs DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME cl-fuse FILENAME cl-fuse)
     (NAME cl-fuse-meta-fs FILENAME cl-fuse-meta-fs)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME command-line-arguments FILENAME command-line-arguments)
     (NAME iterate FILENAME iterate) (NAME pcall FILENAME pcall)
     (NAME pcall-queue FILENAME pcall-queue)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-utf-8 FILENAME trivial-utf-8))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cffi-grovel cffi-toolchain cl-fuse
     cl-fuse-meta-fs cl-ppcre cl-utilities command-line-arguments iterate pcall
     pcall-queue trivial-backtrace trivial-features trivial-utf-8)
    VERSION 20190107-git SIBLINGS NIL PARASITES NIL) */
