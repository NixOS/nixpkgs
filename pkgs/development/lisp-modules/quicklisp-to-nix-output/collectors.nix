/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "collectors";
  version = "20220220-git";

  parasites = [ "collectors/test" ];

  description = "A library providing various collector type macros
   pulled from arnesi into its own library and stripped of dependencies";

  deps = [ args."alexandria" args."closer-mop" args."iterate" args."lisp-unit2" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/collectors/2022-02-20/collectors-20220220-git.tgz";
    sha256 = "04i7f2qmrnan78535a8d0h50lx77h6jjf6ijdjrj0dis9cyb92ny";
  };

  packageName = "collectors";

  asdFilesToKeep = ["collectors.asd"];
  overrides = x: x;
}
/* (SYSTEM collectors DESCRIPTION
    A library providing various collector type macros
   pulled from arnesi into its own library and stripped of dependencies
    SHA256 04i7f2qmrnan78535a8d0h50lx77h6jjf6ijdjrj0dis9cyb92ny URL
    http://beta.quicklisp.org/archive/collectors/2022-02-20/collectors-20220220-git.tgz
    MD5 429ba50dd0a45e5a6e093a13b2d23d0e NAME collectors FILENAME collectors
    DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME closer-mop FILENAME closer-mop) (NAME iterate FILENAME iterate)
     (NAME lisp-unit2 FILENAME lisp-unit2)
     (NAME symbol-munger FILENAME symbol-munger))
    DEPENDENCIES (alexandria closer-mop iterate lisp-unit2 symbol-munger)
    VERSION 20220220-git SIBLINGS NIL PARASITES (collectors/test)) */
