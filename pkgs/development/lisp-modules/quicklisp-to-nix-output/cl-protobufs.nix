args @ { fetchurl, ... }:
rec {
  baseName = ''cl-protobufs'';
  version = ''20170403-git'';

  description = ''Protobufs for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."closer-mop" args."trivial-features" args."trivial-garbage" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-protobufs/2017-04-03/cl-protobufs-20170403-git.tgz'';
    sha256 = ''0ibpl076k8gq79sacg96mzjf5hqkrxzi5wlx3bjap52pla53w4g5'';
  };

  packageName = "cl-protobufs";

  asdFilesToKeep = ["cl-protobufs.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-protobufs DESCRIPTION Protobufs for Common Lisp SHA256
    0ibpl076k8gq79sacg96mzjf5hqkrxzi5wlx3bjap52pla53w4g5 URL
    http://beta.quicklisp.org/archive/cl-protobufs/2017-04-03/cl-protobufs-20170403-git.tgz
    MD5 86c8da92b246b4b77d6107bc5dfaff08 NAME cl-protobufs FILENAME
    cl-protobufs DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME closer-mop FILENAME closer-mop)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES (alexandria babel closer-mop trivial-features trivial-garbage)
    VERSION 20170403-git SIBLINGS (cl-protobufs-tests) PARASITES NIL) */
