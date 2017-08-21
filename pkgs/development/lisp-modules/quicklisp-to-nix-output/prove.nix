args @ { fetchurl, ... }:
rec {
  baseName = ''prove'';
  version = ''20170403-git'';

  description = '''';

  deps = [ args."uiop" args."cl-ppcre" args."cl-colors" args."cl-ansi-text" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/prove/2017-04-03/prove-20170403-git.tgz'';
    sha256 = ''091xxkn9zj22c4gmm8x714k29bs4j0j7akppwh55zjsmrxdhqcpl'';
  };
    
  packageName = "prove";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/prove[.]asd${"$"}' |
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
/* (SYSTEM prove DESCRIPTION NIL SHA256 091xxkn9zj22c4gmm8x714k29bs4j0j7akppwh55zjsmrxdhqcpl URL
    http://beta.quicklisp.org/archive/prove/2017-04-03/prove-20170403-git.tgz MD5 063b615692c8711d2392204ecf1b37b7 NAME prove TESTNAME NIL FILENAME prove DEPS
    ((NAME uiop FILENAME uiop) (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-colors FILENAME cl-colors) (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME alexandria FILENAME alexandria))
    DEPENDENCIES (uiop cl-ppcre cl-colors cl-ansi-text alexandria) VERSION 20170403-git SIBLINGS (cl-test-more prove-asdf prove-test)) */
