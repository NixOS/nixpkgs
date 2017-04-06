args @ { fetchurl, ... }:
rec {
  baseName = ''split-sequence'';
  version = ''1.2'';

  description = ''Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/split-sequence/2015-08-04/split-sequence-1.2.tgz'';
    sha256 = ''12x5yfvinqz9jzxwlsg226103a9sdf67zpzn5izggvdlw0v5qp0l'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/split-sequence[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM split-sequence DESCRIPTION Splits a sequence into a list of subsequences
  delimited by objects satisfying a test.
    SHA256 12x5yfvinqz9jzxwlsg226103a9sdf67zpzn5izggvdlw0v5qp0l URL http://beta.quicklisp.org/archive/split-sequence/2015-08-04/split-sequence-1.2.tgz MD5
    194e24d60f0fba70a059633960052e21 NAME split-sequence TESTNAME NIL FILENAME split-sequence DEPS NIL DEPENDENCIES NIL VERSION 1.2 SIBLINGS NIL) */
