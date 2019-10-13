args @ { fetchurl, ... }:
{
  baseName = ''query-fs'';
  version = ''20190521-git'';

  description = ''High-level virtual FS using CL-Fuse-Meta-FS to represent results of queries'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-fuse" args."cl-fuse-meta-fs" args."cl-ppcre" args."cl-utilities" args."command-line-arguments" args."iterate" args."pcall" args."pcall-queue" args."trivial-backtrace" args."trivial-features" args."trivial-utf-8" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/query-fs/2019-05-21/query-fs-20190521-git.tgz'';
    sha256 = ''1zz917yjjnjx09cl27793056262nz1jhikdaj1mxhgzm3w6ywf39'';
  };

  packageName = "query-fs";

  asdFilesToKeep = ["query-fs.asd"];
  overrides = x: x;
}
/* (SYSTEM query-fs DESCRIPTION
    High-level virtual FS using CL-Fuse-Meta-FS to represent results of queries
    SHA256 1zz917yjjnjx09cl27793056262nz1jhikdaj1mxhgzm3w6ywf39 URL
    http://beta.quicklisp.org/archive/query-fs/2019-05-21/query-fs-20190521-git.tgz
    MD5 1108c91b69007c6ab35b42d70d4dd7a2 NAME query-fs FILENAME query-fs DEPS
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
    VERSION 20190521-git SIBLINGS NIL PARASITES NIL) */
