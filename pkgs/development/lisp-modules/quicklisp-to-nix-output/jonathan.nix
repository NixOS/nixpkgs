args @ { fetchurl, ... }:
rec {
  baseName = ''jonathan'';
  version = ''20170630-git'';

  description = ''High performance JSON encoder and decoder. Currently support: SBCL, CCL.'';

  deps = [ args."trivial-types" args."proc-parse" args."fast-io" args."cl-syntax-annot" args."cl-syntax" args."cl-ppcre" args."cl-annot" args."babel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/jonathan/2017-06-30/jonathan-20170630-git.tgz'';
    sha256 = ''0vxnxs38f6gxw51b69n09p2qmph17jkhwdvwq02sayiq3p4w10bm'';
  };
    
  packageName = "jonathan";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/jonathan[.]asd${"$"}' |
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
/* (SYSTEM jonathan DESCRIPTION High performance JSON encoder and decoder. Currently support: SBCL, CCL. SHA256
    0vxnxs38f6gxw51b69n09p2qmph17jkhwdvwq02sayiq3p4w10bm URL http://beta.quicklisp.org/archive/jonathan/2017-06-30/jonathan-20170630-git.tgz MD5
    5d82723835164f4e3d9c4d031322eb98 NAME jonathan TESTNAME NIL FILENAME jonathan DEPS
    ((NAME trivial-types FILENAME trivial-types) (NAME proc-parse FILENAME proc-parse) (NAME fast-io FILENAME fast-io)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot) (NAME cl-syntax FILENAME cl-syntax) (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-annot FILENAME cl-annot)
     (NAME babel FILENAME babel))
    DEPENDENCIES (trivial-types proc-parse fast-io cl-syntax-annot cl-syntax cl-ppcre cl-annot babel) VERSION 20170630-git SIBLINGS (jonathan-test)) */
