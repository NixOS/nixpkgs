/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-prevalence";
  version = "20210531-git";

  description = "Common Lisp Prevalence Package";

  deps = [ args."alexandria" args."bordeaux-threads" args."s-sysdeps" args."s-xml" args."split-sequence" args."usocket" args."usocket-server" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-prevalence/2021-05-31/cl-prevalence-20210531-git.tgz";
    sha256 = "1608xbfyr0id1nwf9845yfaqz5jbi60vz6c36h70bnzkm4b55s1w";
  };

  packageName = "cl-prevalence";

  asdFilesToKeep = ["cl-prevalence.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-prevalence DESCRIPTION Common Lisp Prevalence Package SHA256
    1608xbfyr0id1nwf9845yfaqz5jbi60vz6c36h70bnzkm4b55s1w URL
    http://beta.quicklisp.org/archive/cl-prevalence/2021-05-31/cl-prevalence-20210531-git.tgz
    MD5 4d2ced14365fb45ef97621298fd24501 NAME cl-prevalence FILENAME
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
    VERSION 20210531-git SIBLINGS (cl-prevalence-test) PARASITES NIL) */
