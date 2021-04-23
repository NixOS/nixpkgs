/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-prevalence";
  version = "20210228-git";

  description = "Common Lisp Prevalence Package";

  deps = [ args."alexandria" args."bordeaux-threads" args."s-sysdeps" args."s-xml" args."split-sequence" args."usocket" args."usocket-server" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-prevalence/2021-02-28/cl-prevalence-20210228-git.tgz";
    sha256 = "0irx60xa7ivlnjg1qzhl7x5sgdjqk53nrx0nji29q639h71czfpl";
  };

  packageName = "cl-prevalence";

  asdFilesToKeep = ["cl-prevalence.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-prevalence DESCRIPTION Common Lisp Prevalence Package SHA256
    0irx60xa7ivlnjg1qzhl7x5sgdjqk53nrx0nji29q639h71czfpl URL
    http://beta.quicklisp.org/archive/cl-prevalence/2021-02-28/cl-prevalence-20210228-git.tgz
    MD5 d67c661693637b837ef7f6b1d4d47f9f NAME cl-prevalence FILENAME
    cl-prevalence DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME s-sysdeps FILENAME s-sysdeps) (NAME s-xml FILENAME s-xml)
     (NAME split-sequence FILENAME split-sequence)
     (NAME usocket FILENAME usocket)
     (NAME usocket-server FILENAME usocket-server))
    DEPENDENCIES
    (alexandria bordeaux-threads s-sysdeps s-xml split-sequence usocket
     usocket-server)
    VERSION 20210228-git SIBLINGS (cl-prevalence-test) PARASITES NIL) */
