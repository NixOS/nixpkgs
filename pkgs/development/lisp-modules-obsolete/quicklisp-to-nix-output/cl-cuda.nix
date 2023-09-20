/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-cuda";
  version = "20210807-git";

  description = "Cl-cuda is a library to use NVIDIA CUDA in Common Lisp programs.";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-annot" args."cl-pattern" args."cl-ppcre" args."cl-reexport" args."cl-syntax" args."cl-syntax-annot" args."external-program" args."named-readtables" args."osicat" args."split-sequence" args."trivial-features" args."trivial-types" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-cuda/2021-08-07/cl-cuda-20210807-git.tgz";
    sha256 = "0q974qrjxdn7c53frpac0hz9wnxhnf3lf8xngrc8zkphp1windc0";
  };

  packageName = "cl-cuda";

  asdFilesToKeep = ["cl-cuda.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-cuda DESCRIPTION
    Cl-cuda is a library to use NVIDIA CUDA in Common Lisp programs. SHA256
    0q974qrjxdn7c53frpac0hz9wnxhnf3lf8xngrc8zkphp1windc0 URL
    http://beta.quicklisp.org/archive/cl-cuda/2021-08-07/cl-cuda-20210807-git.tgz
    MD5 0502aed4f738192adee742b7757ee8d7 NAME cl-cuda FILENAME cl-cuda DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME cl-annot FILENAME cl-annot) (NAME cl-pattern FILENAME cl-pattern)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-reexport FILENAME cl-reexport)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME external-program FILENAME external-program)
     (NAME named-readtables FILENAME named-readtables)
     (NAME osicat FILENAME osicat)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain cl-annot cl-pattern
     cl-ppcre cl-reexport cl-syntax cl-syntax-annot external-program
     named-readtables osicat split-sequence trivial-features trivial-types)
    VERSION 20210807-git SIBLINGS
    (cl-cuda-examples cl-cuda-interop-examples cl-cuda-interop cl-cuda-misc)
    PARASITES NIL) */
