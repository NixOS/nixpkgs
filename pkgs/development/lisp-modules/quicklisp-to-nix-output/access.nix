args @ { fetchurl, ... }:
rec {
  baseName = ''access'';
  version = ''20151218-git'';

  parasites = [ "access-test" ];

  description = ''A library providing functions that unify data-structure access for Common Lisp:
      access and (setf access)'';

  deps = [ args."alexandria" args."anaphora" args."cl-interpol" args."cl-ppcre" args."cl-unicode" args."closer-mop" args."flexi-streams" args."iterate" args."lisp-unit2" args."named-readtables" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/access/2015-12-18/access-20151218-git.tgz'';
    sha256 = ''0f4257cxd1rpp46wm2qbnk0ynlc3dli9ib4qbn45hglh8zy7snfl'';
  };

  packageName = "access";

  asdFilesToKeep = ["access.asd"];
  overrides = x: x;
}
/* (SYSTEM access DESCRIPTION
    A library providing functions that unify data-structure access for Common Lisp:
      access and (setf access)
    SHA256 0f4257cxd1rpp46wm2qbnk0ynlc3dli9ib4qbn45hglh8zy7snfl URL
    http://beta.quicklisp.org/archive/access/2015-12-18/access-20151218-git.tgz
    MD5 a6f1eb4a1823b04c6db4fa2dc16d648f NAME access FILENAME access DEPS
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
    VERSION 20151218-git SIBLINGS NIL PARASITES (access-test)) */
