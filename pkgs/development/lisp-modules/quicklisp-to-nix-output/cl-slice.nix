/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-slice";
  version = "20210531-git";

  parasites = [ "cl-slice-tests" ];

  description = "DSL for array slices in Common Lisp.";

  deps = [ args."alexandria" args."anaphora" args."clunit" args."let-plus" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-slice/2021-05-31/cl-slice-20210531-git.tgz";
    sha256 = "1jkm8yrnc0x2nx4bwwk56xda1r5h2aw0q4yfbv8lywaiwj92v7hk";
  };

  packageName = "cl-slice";

  asdFilesToKeep = ["cl-slice.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-slice DESCRIPTION DSL for array slices in Common Lisp. SHA256
    1jkm8yrnc0x2nx4bwwk56xda1r5h2aw0q4yfbv8lywaiwj92v7hk URL
    http://beta.quicklisp.org/archive/cl-slice/2021-05-31/cl-slice-20210531-git.tgz
    MD5 d7be90ed28b5c316b1f31b4f567bd725 NAME cl-slice FILENAME cl-slice DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME clunit FILENAME clunit) (NAME let-plus FILENAME let-plus))
    DEPENDENCIES (alexandria anaphora clunit let-plus) VERSION 20210531-git
    SIBLINGS NIL PARASITES (cl-slice-tests)) */
