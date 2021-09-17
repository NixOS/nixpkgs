/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-hooks";
  version = "architecture.hooks-20181210-git";

  parasites = [ "cl-hooks/test" ];

  description = "This system provides the hooks extension point
mechanism (as known, e.g., from GNU Emacs).";

  deps = [ args."alexandria" args."anaphora" args."closer-mop" args."fiveam" args."let-plus" args."trivial-garbage" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/architecture.hooks/2018-12-10/architecture.hooks-20181210-git.tgz";
    sha256 = "04l8rjmgsd7i580rpm1wndz1jcvfqrmwllnkh3h7als3azi3q2ns";
  };

  packageName = "cl-hooks";

  asdFilesToKeep = ["cl-hooks.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-hooks DESCRIPTION This system provides the hooks extension point
mechanism (as known, e.g., from GNU Emacs).
    SHA256 04l8rjmgsd7i580rpm1wndz1jcvfqrmwllnkh3h7als3azi3q2ns URL
    http://beta.quicklisp.org/archive/architecture.hooks/2018-12-10/architecture.hooks-20181210-git.tgz
    MD5 698bdb1309cae19fb8f0e1e425ba4cd9 NAME cl-hooks FILENAME cl-hooks DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME closer-mop FILENAME closer-mop) (NAME fiveam FILENAME fiveam)
     (NAME let-plus FILENAME let-plus)
     (NAME trivial-garbage FILENAME trivial-garbage))
    DEPENDENCIES
    (alexandria anaphora closer-mop fiveam let-plus trivial-garbage) VERSION
    architecture.hooks-20181210-git SIBLINGS NIL PARASITES (cl-hooks/test)) */
