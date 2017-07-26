args @ { fetchurl, ... }:
rec {
  baseName = ''lquery'';
  version = ''20170516-git'';

  description = ''A library to allow jQuery-like HTML/DOM manipulation.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lquery/2017-05-16/lquery-20170516-git.tgz'';
    sha256 = ''11i6kwz4d8918a32z826v85qs2alpsfkvlcha4j7mnbfnzgy7gy7'';
  };
    
  packageName = "lquery";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/lquery[.]asd${"$"}' |
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
/* (SYSTEM lquery DESCRIPTION A library to allow jQuery-like HTML/DOM manipulation. SHA256 11i6kwz4d8918a32z826v85qs2alpsfkvlcha4j7mnbfnzgy7gy7 URL
    http://beta.quicklisp.org/archive/lquery/2017-05-16/lquery-20170516-git.tgz MD5 2190045b167685bfffdd01f5af9aa9a1 NAME lquery TESTNAME NIL FILENAME lquery
    DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS (lquery-test)) */
