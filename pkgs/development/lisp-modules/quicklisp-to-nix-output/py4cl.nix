/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "py4cl";
  version = "20210228-git";

  description = "Call Python libraries from Common Lisp";

  deps = [ args."cl-json" args."ieee-floats" args."numpy-file-format" args."trivial-features" args."trivial-garbage" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/py4cl/2021-02-28/py4cl-20210228-git.tgz";
    sha256 = "1cbfqwz742icyydgdc4l1yj63x046mi7j0gglavrd75d3fqnjky4";
  };

  packageName = "py4cl";

  asdFilesToKeep = ["py4cl.asd"];
  overrides = x: x;
}
/* (SYSTEM py4cl DESCRIPTION Call Python libraries from Common Lisp SHA256
    1cbfqwz742icyydgdc4l1yj63x046mi7j0gglavrd75d3fqnjky4 URL
    http://beta.quicklisp.org/archive/py4cl/2021-02-28/py4cl-20210228-git.tgz
    MD5 63b115198c82ec3d925394c44221dfa7 NAME py4cl FILENAME py4cl DEPS
    ((NAME cl-json FILENAME cl-json) (NAME ieee-floats FILENAME ieee-floats)
     (NAME numpy-file-format FILENAME numpy-file-format)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage) (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (cl-json ieee-floats numpy-file-format trivial-features trivial-garbage
     uiop)
    VERSION 20210228-git SIBLINGS NIL PARASITES NIL) */
