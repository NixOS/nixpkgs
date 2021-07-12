/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-environments";
  version = "20210411-git";

  parasites = [ "cl-environments/test" ];

  description = "Implements the CLTL2 environment access functionality
                for implementations which do not provide the
                functionality to the programmer.";

  deps = [ args."alexandria" args."anaphora" args."cl-ansi-text" args."cl-colors" args."cl-ppcre" args."closer-mop" args."collectors" args."iterate" args."optima" args."prove" args."prove-asdf" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-environments/2021-04-11/cl-environments-20210411-git.tgz";
    sha256 = "1xs1wwf6fmzq5zxmv5d9f2mfmhc7j2w03519ky6id5md75j68lhk";
  };

  packageName = "cl-environments";

  asdFilesToKeep = ["cl-environments.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-environments DESCRIPTION
    Implements the CLTL2 environment access functionality
                for implementations which do not provide the
                functionality to the programmer.
    SHA256 1xs1wwf6fmzq5zxmv5d9f2mfmhc7j2w03519ky6id5md75j68lhk URL
    http://beta.quicklisp.org/archive/cl-environments/2021-04-11/cl-environments-20210411-git.tgz
    MD5 87b7c0186d37d30d24df11d021ab4fba NAME cl-environments FILENAME
    cl-environments DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-colors FILENAME cl-colors) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closer-mop FILENAME closer-mop)
     (NAME collectors FILENAME collectors) (NAME iterate FILENAME iterate)
     (NAME optima FILENAME optima) (NAME prove FILENAME prove)
     (NAME prove-asdf FILENAME prove-asdf)
     (NAME symbol-munger FILENAME symbol-munger))
    DEPENDENCIES
    (alexandria anaphora cl-ansi-text cl-colors cl-ppcre closer-mop collectors
     iterate optima prove prove-asdf symbol-munger)
    VERSION 20210411-git SIBLINGS NIL PARASITES (cl-environments/test)) */
