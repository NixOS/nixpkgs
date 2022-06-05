/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "access";
  version = "20210124-git";

  parasites = [ "access-test" ];

  description = "A library providing functions that unify data-structure access for Common Lisp:
      access and (setf access)";

  deps = [ args."alexandria" args."anaphora" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."closer-mop" args."flexi-streams" args."iterate" args."lisp-unit2" args."named-readtables" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/access/2021-01-24/access-20210124-git.tgz";
    sha256 = "1n4j15v1ikspchcbb0bn15kk3lh78f6bxk56cs4arimm8bisyqlq";
  };

  packageName = "access";

  asdFilesToKeep = ["access.asd"];
  overrides = x: x;
}
/* (SYSTEM access DESCRIPTION
    A library providing functions that unify data-structure access for Common Lisp:
      access and (setf access)
    SHA256 1n4j15v1ikspchcbb0bn15kk3lh78f6bxk56cs4arimm8bisyqlq URL
    http://beta.quicklisp.org/archive/access/2021-01-24/access-20210124-git.tgz
    MD5 d2d7d9826cbfb3de568d05a4d6bacdbe NAME access FILENAME access DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME cl-interpol FILENAME cl-interpol) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME closer-mop FILENAME closer-mop)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME iterate FILENAME iterate) (NAME lisp-unit2 FILENAME lisp-unit2)
     (NAME named-readtables FILENAME named-readtables))
    DEPENDENCIES
    (alexandria anaphora cl-interpol cl-ppcre cl-unicode closer-mop
     flexi-streams iterate lisp-unit2 named-readtables)
    VERSION 20210124-git SIBLINGS NIL PARASITES (access-test)) */
