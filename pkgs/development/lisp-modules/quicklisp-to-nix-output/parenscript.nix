args @ { fetchurl, ... }:
rec {
  baseName = ''parenscript'';
  version = ''Parenscript-2.6'';

  description = ''Lisp to JavaScript transpiler'';

  deps = [ args."named-readtables" args."cl-ppcre" args."anaphora" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/parenscript/2016-03-18/Parenscript-2.6.tgz'';
    sha256 = ''1hvr407fz7gzaxqbnki4k3l44qvl7vk6p5pn7811nrv6lk3kp5li'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/parenscript[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM parenscript DESCRIPTION Lisp to JavaScript transpiler SHA256 1hvr407fz7gzaxqbnki4k3l44qvl7vk6p5pn7811nrv6lk3kp5li URL
    http://beta.quicklisp.org/archive/parenscript/2016-03-18/Parenscript-2.6.tgz MD5 dadecc13f2918bc618fb143e893deb99 NAME parenscript TESTNAME NIL FILENAME
    parenscript DEPS ((NAME named-readtables) (NAME cl-ppcre) (NAME anaphora)) DEPENDENCIES (named-readtables cl-ppcre anaphora) VERSION Parenscript-2.6
    SIBLINGS (parenscript.test)) */
