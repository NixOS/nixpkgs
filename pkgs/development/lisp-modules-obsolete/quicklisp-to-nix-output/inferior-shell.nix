/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "inferior-shell";
  version = "20200925-git";

  parasites = [ "inferior-shell/test" ];

  description = "spawn local or remote processes and shell pipes";

  deps = [ args."alexandria" args."asdf" args."closer-mop" args."fare-mop" args."fare-quasiquote" args."fare-quasiquote-extras" args."fare-quasiquote-optima" args."fare-quasiquote-readtable" args."fare-utils" args."hu_dot_dwim_dot_stefil" args."introspect-environment" args."iterate" args."lisp-namespace" args."named-readtables" args."trivia" args."trivia_dot_balland2006" args."trivia_dot_level0" args."trivia_dot_level1" args."trivia_dot_level2" args."trivia_dot_quasiquote" args."trivia_dot_trivial" args."trivial-cltl2" args."type-i" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/inferior-shell/2020-09-25/inferior-shell-20200925-git.tgz";
    sha256 = "1hykybcmdpcjk0irl4f1lmqc4aawpp1zfvh27qp6mldsibra7l80";
  };

  packageName = "inferior-shell";

  asdFilesToKeep = ["inferior-shell.asd"];
  overrides = x: x;
}
/* (SYSTEM inferior-shell DESCRIPTION
    spawn local or remote processes and shell pipes SHA256
    1hykybcmdpcjk0irl4f1lmqc4aawpp1zfvh27qp6mldsibra7l80 URL
    http://beta.quicklisp.org/archive/inferior-shell/2020-09-25/inferior-shell-20200925-git.tgz
    MD5 7ca5f15446ef80715758610a930bccba NAME inferior-shell FILENAME
    inferior-shell DEPS
    ((NAME alexandria FILENAME alexandria) (NAME asdf FILENAME asdf)
     (NAME closer-mop FILENAME closer-mop) (NAME fare-mop FILENAME fare-mop)
     (NAME fare-quasiquote FILENAME fare-quasiquote)
     (NAME fare-quasiquote-extras FILENAME fare-quasiquote-extras)
     (NAME fare-quasiquote-optima FILENAME fare-quasiquote-optima)
     (NAME fare-quasiquote-readtable FILENAME fare-quasiquote-readtable)
     (NAME fare-utils FILENAME fare-utils)
     (NAME hu.dwim.stefil FILENAME hu_dot_dwim_dot_stefil)
     (NAME introspect-environment FILENAME introspect-environment)
     (NAME iterate FILENAME iterate)
     (NAME lisp-namespace FILENAME lisp-namespace)
     (NAME named-readtables FILENAME named-readtables)
     (NAME trivia FILENAME trivia)
     (NAME trivia.balland2006 FILENAME trivia_dot_balland2006)
     (NAME trivia.level0 FILENAME trivia_dot_level0)
     (NAME trivia.level1 FILENAME trivia_dot_level1)
     (NAME trivia.level2 FILENAME trivia_dot_level2)
     (NAME trivia.quasiquote FILENAME trivia_dot_quasiquote)
     (NAME trivia.trivial FILENAME trivia_dot_trivial)
     (NAME trivial-cltl2 FILENAME trivial-cltl2) (NAME type-i FILENAME type-i))
    DEPENDENCIES
    (alexandria asdf closer-mop fare-mop fare-quasiquote fare-quasiquote-extras
     fare-quasiquote-optima fare-quasiquote-readtable fare-utils hu.dwim.stefil
     introspect-environment iterate lisp-namespace named-readtables trivia
     trivia.balland2006 trivia.level0 trivia.level1 trivia.level2
     trivia.quasiquote trivia.trivial trivial-cltl2 type-i)
    VERSION 20200925-git SIBLINGS NIL PARASITES (inferior-shell/test)) */
