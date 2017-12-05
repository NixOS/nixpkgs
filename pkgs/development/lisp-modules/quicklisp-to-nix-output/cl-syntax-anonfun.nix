args @ { fetchurl, ... }:
rec {
  baseName = ''cl-syntax-anonfun'';
  version = ''cl-syntax-20150407-git'';

  description = ''CL-Syntax Reader Syntax for cl-anonfun'';

  deps = [ args."cl-anonfun" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz'';
    sha256 = ''1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n'';
  };
    
  packageName = "cl-syntax-anonfun";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-syntax-anonfun[.]asd${"$"}' |
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
/* (SYSTEM cl-syntax-anonfun DESCRIPTION CL-Syntax Reader Syntax for cl-anonfun SHA256 1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n URL
    http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz MD5 602b84143aafe59d65f4e08ac20a124a NAME cl-syntax-anonfun TESTNAME NIL
    FILENAME cl-syntax-anonfun DEPS ((NAME cl-anonfun FILENAME cl-anonfun)) DEPENDENCIES (cl-anonfun) VERSION cl-syntax-20150407-git SIBLINGS
    (cl-syntax-annot cl-syntax-clsql cl-syntax-fare-quasiquote cl-syntax-interpol cl-syntax-markup cl-syntax)) */
