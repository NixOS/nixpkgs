args @ { fetchurl, ... }:
rec {
  baseName = ''jonathan'';
  version = ''20170124-git'';

  description = ''High performance JSON encoder and decoder. Currently support: SBCL, CCL.'';

  deps = [ args."trivial-types" args."proc-parse" args."fast-io" args."cl-syntax-annot" args."cl-syntax" args."cl-ppcre" args."cl-annot" args."babel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/jonathan/2017-01-24/jonathan-20170124-git.tgz'';
    sha256 = ''1r54w7i1fxaqz6q7idamcy3bvsg0pvfjcs2qq4dag519zwcpln5l'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/jonathan[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM jonathan DESCRIPTION High performance JSON encoder and decoder. Currently support: SBCL, CCL. SHA256
    1r54w7i1fxaqz6q7idamcy3bvsg0pvfjcs2qq4dag519zwcpln5l URL http://beta.quicklisp.org/archive/jonathan/2017-01-24/jonathan-20170124-git.tgz MD5
    f33377a22a3b1d948f294985acec20ad NAME jonathan TESTNAME NIL FILENAME jonathan DEPS
    ((NAME trivial-types) (NAME proc-parse) (NAME fast-io) (NAME cl-syntax-annot) (NAME cl-syntax) (NAME cl-ppcre) (NAME cl-annot) (NAME babel)) DEPENDENCIES
    (trivial-types proc-parse fast-io cl-syntax-annot cl-syntax cl-ppcre cl-annot babel) VERSION 20170124-git SIBLINGS (jonathan-test)) */
