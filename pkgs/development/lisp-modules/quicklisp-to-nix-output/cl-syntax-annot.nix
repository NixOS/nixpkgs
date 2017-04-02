args @ { fetchurl, ... }:
rec {
  baseName = ''cl-syntax-annot'';
  version = ''cl-syntax-20150407-git'';

  description = ''CL-Syntax Reader Syntax for cl-annot'';

  deps = [ args."cl-annot" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz'';
    sha256 = ''1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-syntax-annot[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-syntax-annot DESCRIPTION CL-Syntax Reader Syntax for cl-annot SHA256 1pz9a7hiql493ax5qgs9zb3bmvf0nnmmgdx14s4j2apdy2m34v8n URL
    http://beta.quicklisp.org/archive/cl-syntax/2015-04-07/cl-syntax-20150407-git.tgz MD5 602b84143aafe59d65f4e08ac20a124a NAME cl-syntax-annot TESTNAME NIL
    FILENAME cl-syntax-annot DEPS ((NAME cl-annot)) DEPENDENCIES (cl-annot) VERSION cl-syntax-20150407-git SIBLINGS
    (cl-syntax-anonfun cl-syntax-clsql cl-syntax-fare-quasiquote cl-syntax-interpol cl-syntax-markup cl-syntax)) */
