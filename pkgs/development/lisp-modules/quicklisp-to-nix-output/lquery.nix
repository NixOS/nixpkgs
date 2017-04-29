args @ { fetchurl, ... }:
rec {
  baseName = ''lquery'';
  version = ''20160929-git'';

  description = ''A library to allow jQuery-like HTML/DOM manipulation.'';

  deps = [ args."plump" args."form-fiddle" args."clss" args."array-utils" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lquery/2016-09-29/lquery-20160929-git.tgz'';
    sha256 = ''1kqc0n4zh44yay9vbv6wirk3122q7if2999146lrgada5fy17r7x'';
  };

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
/* (SYSTEM lquery DESCRIPTION A library to allow jQuery-like HTML/DOM manipulation. SHA256 1kqc0n4zh44yay9vbv6wirk3122q7if2999146lrgada5fy17r7x URL
    http://beta.quicklisp.org/archive/lquery/2016-09-29/lquery-20160929-git.tgz MD5 072a796075862c96dcd6f227d79dc2b7 NAME lquery TESTNAME NIL FILENAME lquery
    DEPS ((NAME plump) (NAME form-fiddle) (NAME clss) (NAME array-utils)) DEPENDENCIES (plump form-fiddle clss array-utils) VERSION 20160929-git SIBLINGS
    (lquery-test)) */
