args @ { fetchurl, ... }:
rec {
  baseName = ''map-set'';
  version = ''20160628-hg'';

  description = ''Set-like data structure.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/map-set/2016-06-28/map-set-20160628-hg.tgz'';
    sha256 = ''15fbha43a5153ah836djp9dbg41728adjrzwryv68gcqs31rjk9v'';
  };
    
  packageName = "map-set";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/map-set[.]asd${"$"}' |
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
/* (SYSTEM map-set DESCRIPTION Set-like data structure. SHA256 15fbha43a5153ah836djp9dbg41728adjrzwryv68gcqs31rjk9v URL
    http://beta.quicklisp.org/archive/map-set/2016-06-28/map-set-20160628-hg.tgz MD5 49cf6b527841b717b8696efaa7bb6389 NAME map-set TESTNAME NIL FILENAME
    map-set DEPS NIL DEPENDENCIES NIL VERSION 20160628-hg SIBLINGS NIL) */
