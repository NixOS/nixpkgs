args @ { fetchurl, ... }:
rec {
  baseName = ''cl-prevalence'';
  version = ''20190521-git'';

  description = ''Common Lisp Prevalence Package'';

  deps = [ args."s-sysdeps" args."s-xml" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-prevalence/2019-05-21/cl-prevalence-20190521-git.tgz'';
    sha256 = ''16j7ccpjdidz1p6mgib06viy966ckxzgkd6xcvg96xmr4hkksljf'';
  };

  packageName = "cl-prevalence";

  asdFilesToKeep = ["cl-prevalence.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-prevalence DESCRIPTION Common Lisp Prevalence Package SHA256
    16j7ccpjdidz1p6mgib06viy966ckxzgkd6xcvg96xmr4hkksljf URL
    http://beta.quicklisp.org/archive/cl-prevalence/2019-05-21/cl-prevalence-20190521-git.tgz
    MD5 6c81a4fe41bd63eef9ff8f4cc41aa6b9 NAME cl-prevalence FILENAME
    cl-prevalence DEPS
    ((NAME s-sysdeps FILENAME s-sysdeps) (NAME s-xml FILENAME s-xml))
    DEPENDENCIES (s-sysdeps s-xml) VERSION 20190521-git SIBLINGS
    (cl-prevalence-test) PARASITES NIL) */
