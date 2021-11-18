/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "magicl";
  version = "v0.9.1";

  parasites = [ "magicl/core" "magicl/ext" "magicl/ext-blas" "magicl/ext-expokit" "magicl/ext-lapack" ];

  description = "Matrix Algebra proGrams In Common Lisp";

  deps = [ args."abstract-classes" args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-libffi" args."cffi-toolchain" args."closer-mop" args."global-vars" args."interface" args."policy-cond" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/magicl/2021-04-11/magicl-v0.9.1.tgz";
    sha256 = "1vsi82l7w1ijp3f7f8hi9pm91www3a9fb8nnljiwypnjrjbrkwld";
  };

  packageName = "magicl";

  asdFilesToKeep = ["magicl.asd"];
  overrides = x: x;
}
/* (SYSTEM magicl DESCRIPTION Matrix Algebra proGrams In Common Lisp SHA256
    1vsi82l7w1ijp3f7f8hi9pm91www3a9fb8nnljiwypnjrjbrkwld URL
    http://beta.quicklisp.org/archive/magicl/2021-04-11/magicl-v0.9.1.tgz MD5
    5b28a64d6577cc9b97b7719a82ae4d1c NAME magicl FILENAME magicl DEPS
    ((NAME abstract-classes FILENAME abstract-classes)
     (NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-libffi FILENAME cffi-libffi)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME closer-mop FILENAME closer-mop)
     (NAME global-vars FILENAME global-vars)
     (NAME interface FILENAME interface)
     (NAME policy-cond FILENAME policy-cond)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (abstract-classes alexandria babel cffi cffi-grovel cffi-libffi
     cffi-toolchain closer-mop global-vars interface policy-cond
     trivial-features)
    VERSION v0.9.1 SIBLINGS
    (magicl-examples magicl-gen magicl-tests magicl-transcendental) PARASITES
    (magicl/core magicl/ext magicl/ext-blas magicl/ext-expokit
     magicl/ext-lapack)) */
