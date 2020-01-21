args @ { fetchurl, ... }:
rec {
  baseName = ''esrap-peg'';
  version = ''20170403-git'';

  description = ''A wrapper around Esrap to allow generating Esrap grammars from PEG definitions'';

  deps = [ args."alexandria" args."cl-unification" args."esrap" args."iterate" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap-peg/2017-04-03/esrap-peg-20170403-git.tgz'';
    sha256 = ''123pl1p87f8llpzs19abn5idivl4b5mxrc9rflqirbsz3gyc8wl9'';
  };

  packageName = "esrap-peg";

  asdFilesToKeep = ["esrap-peg.asd"];
  overrides = x: x;
}
/* (SYSTEM esrap-peg DESCRIPTION
    A wrapper around Esrap to allow generating Esrap grammars from PEG definitions
    SHA256 123pl1p87f8llpzs19abn5idivl4b5mxrc9rflqirbsz3gyc8wl9 URL
    http://beta.quicklisp.org/archive/esrap-peg/2017-04-03/esrap-peg-20170403-git.tgz
    MD5 0d31f9c82d88ad11ee3d309128e7803c NAME esrap-peg FILENAME esrap-peg DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME cl-unification FILENAME cl-unification) (NAME esrap FILENAME esrap)
     (NAME iterate FILENAME iterate))
    DEPENDENCIES (alexandria cl-unification esrap iterate) VERSION 20170403-git
    SIBLINGS NIL PARASITES NIL) */
