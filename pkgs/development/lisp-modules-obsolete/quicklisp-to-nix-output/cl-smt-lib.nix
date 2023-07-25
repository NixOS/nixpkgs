/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-smt-lib";
  version = "20211020-git";

  description = "SMT object supporting SMT-LIB communication over input and output streams";

  deps = [ args."asdf-package-system" args."named-readtables" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-smt-lib/2021-10-20/cl-smt-lib-20211020-git.tgz";
    sha256 = "1x2d79xcc0c56cb02axly6c10y6dmvxcpr3f16qry02rpfqys3qm";
  };

  packageName = "cl-smt-lib";

  asdFilesToKeep = ["cl-smt-lib.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-smt-lib DESCRIPTION
    SMT object supporting SMT-LIB communication over input and output streams
    SHA256 1x2d79xcc0c56cb02axly6c10y6dmvxcpr3f16qry02rpfqys3qm URL
    http://beta.quicklisp.org/archive/cl-smt-lib/2021-10-20/cl-smt-lib-20211020-git.tgz
    MD5 f22b48a87b78fb5b38b35d780d34cd77 NAME cl-smt-lib FILENAME cl-smt-lib
    DEPS
    ((NAME asdf-package-system FILENAME asdf-package-system)
     (NAME named-readtables FILENAME named-readtables)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (asdf-package-system named-readtables trivial-gray-streams)
    VERSION 20211020-git SIBLINGS NIL PARASITES NIL) */
