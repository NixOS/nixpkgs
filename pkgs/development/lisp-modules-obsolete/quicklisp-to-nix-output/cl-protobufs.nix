/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-protobufs";
  version = "20200325-git";

  description = "Protobufs for Common Lisp";

  deps = [ args."alexandria" args."asdf" args."babel" args."closer-mop" args."trivial-features" args."trivial-garbage" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-protobufs/2020-03-25/cl-protobufs-20200325-git.tgz";
    sha256 = "1sgvp038bvd3mq2f0xh4wawf8h21jmw449yjyahidh1zfqdibpin";
  };

  packageName = "cl-protobufs";

  asdFilesToKeep = ["cl-protobufs.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-protobufs DESCRIPTION Protobufs for Common Lisp SHA256
    1sgvp038bvd3mq2f0xh4wawf8h21jmw449yjyahidh1zfqdibpin URL
    http://beta.quicklisp.org/archive/cl-protobufs/2020-03-25/cl-protobufs-20200325-git.tgz
    MD5 9fb9af8bd53796b3cf8f358762095899 NAME cl-protobufs FILENAME
    cl-protobufs DEPS
    ((NAME alexandria FILENAME alexandria) (NAME asdf FILENAME asdf)
     (NAME babel FILENAME babel) (NAME closer-mop FILENAME closer-mop)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES
    (alexandria asdf babel closer-mop trivial-features trivial-garbage) VERSION
    20200325-git SIBLINGS (cl-protobufs-tests) PARASITES NIL) */
