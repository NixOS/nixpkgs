args @ { fetchurl, ... }:
rec {
  baseName = ''cl-prevalence'';
  version = ''20191130-git'';

  description = ''Common Lisp Prevalence Package'';

  deps = [ args."s-sysdeps" args."s-xml" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-prevalence/2019-11-30/cl-prevalence-20191130-git.tgz'';
    sha256 = ''01pk77nhyv89zd9sf78i0gch9swxlaw3sqnjdnx4329ww6qv2sg4'';
  };

  packageName = "cl-prevalence";

  asdFilesToKeep = ["cl-prevalence.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-prevalence DESCRIPTION Common Lisp Prevalence Package SHA256
    01pk77nhyv89zd9sf78i0gch9swxlaw3sqnjdnx4329ww6qv2sg4 URL
    http://beta.quicklisp.org/archive/cl-prevalence/2019-11-30/cl-prevalence-20191130-git.tgz
    MD5 7615cb79ec797a5520941aedc3101390 NAME cl-prevalence FILENAME
    cl-prevalence DEPS
    ((NAME s-sysdeps FILENAME s-sysdeps) (NAME s-xml FILENAME s-xml))
    DEPENDENCIES (s-sysdeps s-xml) VERSION 20191130-git SIBLINGS
    (cl-prevalence-test) PARASITES NIL) */
