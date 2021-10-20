/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-smt-lib";
  version = "20210630-git";

  description = "SMT object supporting SMT-LIB communication over input and output streams";

  deps = [ args."asdf-package-system" args."named-readtables" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-smt-lib/2021-06-30/cl-smt-lib-20210630-git.tgz";
    sha256 = "0vrqzp6im2nvq6yfv4ysq4zv3m80v33apggzqq8r8j1zvbjjzrvm";
  };

  packageName = "cl-smt-lib";

  asdFilesToKeep = ["cl-smt-lib.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-smt-lib DESCRIPTION
    SMT object supporting SMT-LIB communication over input and output streams
    SHA256 0vrqzp6im2nvq6yfv4ysq4zv3m80v33apggzqq8r8j1zvbjjzrvm URL
    http://beta.quicklisp.org/archive/cl-smt-lib/2021-06-30/cl-smt-lib-20210630-git.tgz
    MD5 a10f913b43ba0ca99ee87a66e2f508ac NAME cl-smt-lib FILENAME cl-smt-lib
    DEPS
    ((NAME asdf-package-system FILENAME asdf-package-system)
     (NAME named-readtables FILENAME named-readtables)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (asdf-package-system named-readtables trivial-gray-streams)
    VERSION 20210630-git SIBLINGS NIL PARASITES NIL) */
