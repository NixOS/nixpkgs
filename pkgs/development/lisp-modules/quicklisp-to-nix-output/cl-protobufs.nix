args @ { fetchurl, ... }:
{
  baseName = ''cl-protobufs'';
  version = ''20180328-git'';

  description = ''Protobufs for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."closer-mop" args."trivial-features" args."trivial-garbage" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-protobufs/2018-03-28/cl-protobufs-20180328-git.tgz'';
    sha256 = ''0pkm5mphs2yks8v1i8wxq92ywm6fx9lasybrx8rccrd7dm156nzj'';
  };

  packageName = "cl-protobufs";

  asdFilesToKeep = ["cl-protobufs.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-protobufs DESCRIPTION Protobufs for Common Lisp SHA256
    0pkm5mphs2yks8v1i8wxq92ywm6fx9lasybrx8rccrd7dm156nzj URL
    http://beta.quicklisp.org/archive/cl-protobufs/2018-03-28/cl-protobufs-20180328-git.tgz
    MD5 6573322beb8f27653f0c9b418c5f5b92 NAME cl-protobufs FILENAME
    cl-protobufs DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME closer-mop FILENAME closer-mop)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES (alexandria babel closer-mop trivial-features trivial-garbage)
    VERSION 20180328-git SIBLINGS (cl-protobufs-tests) PARASITES NIL) */
