args @ { fetchurl, ... }:
rec {
  baseName = ''cl-syntax'';
  version = ''20150407-git'';

  description = ''Reader Syntax Coventions for Common Lisp and SLIME'';

  deps = [ args."trivial-types" args."named-readtables" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz'';
    sha256 = ''1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n'';
  };
    
  packageName = "cl-syntax";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-syntax[.]asd${"$"}' |
        while read f; do
          env -i \
          NIX_LISP="$NIX_LISP" \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(progn
            (asdf:load-system :$(basename "$f" .asd))
            (asdf:perform (quote asdf:compile-bundle-op) :$(basename "$f" .asd))
            (ignore-errors (asdf:perform (quote asdf:deliver-asd-op) :$(basename "$f" .asd)))
            )'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-syntax DESCRIPTION Reader Syntax Coventions for Common Lisp and SLIME SHA256 1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n URL
    http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz MD5 602b84143aafe59d65f4e08ac20a124a NAME cl-syntax TESTNAME NIL FILENAME
    cl-syntax DEPS ((NAME trivial-types FILENAME trivial-types) (NAME named-readtables FILENAME named-readtables)) DEPENDENCIES
    (trivial-types named-readtables) VERSION 20150407-git SIBLINGS
    (cl-syntax-annot cl-syntax-anonfun cl-syntax-clsql cl-syntax-fare-quasiquote cl-syntax-interpol cl-syntax-markup)) */
