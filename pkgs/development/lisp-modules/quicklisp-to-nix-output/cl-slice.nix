/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-slice";
  version = "20171130-git";

  parasites = [ "cl-slice-tests" ];

  description = "DSL for array slices in Common Lisp.";

  deps = [ args."alexandria" args."anaphora" args."clunit" args."let-plus" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-slice/2017-11-30/cl-slice-20171130-git.tgz";
    sha256 = "0nay95qsnck40kdxjgjdii5rcgrdhf880pg9ajmbxilgw84xb2zn";
  };

  packageName = "cl-slice";

  asdFilesToKeep = ["cl-slice.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-slice DESCRIPTION DSL for array slices in Common Lisp. SHA256
    0nay95qsnck40kdxjgjdii5rcgrdhf880pg9ajmbxilgw84xb2zn URL
    http://beta.quicklisp.org/archive/cl-slice/2017-11-30/cl-slice-20171130-git.tgz
    MD5 b83a7a9aa503dc01cba43cf1e494e67d NAME cl-slice FILENAME cl-slice DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME clunit FILENAME clunit) (NAME let-plus FILENAME let-plus))
    DEPENDENCIES (alexandria anaphora clunit let-plus) VERSION 20171130-git
    SIBLINGS NIL PARASITES (cl-slice-tests)) */
