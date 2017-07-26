args @ { fetchurl, ... }:
rec {
  baseName = ''yason'';
  version = ''v0.7.6'';

  description = ''JSON parser/encoder'';

  deps = [ args."alexandria" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/yason/2016-02-08/yason-v0.7.6.tgz'';
    sha256 = ''00gfn14bvnw0in03y5m2ssgvhy3ppf5a3s0rf7mf4rq00c5ifchk'';
  };
    
  packageName = "yason";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/yason[.]asd${"$"}' |
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
/* (SYSTEM yason DESCRIPTION JSON parser/encoder SHA256 00gfn14bvnw0in03y5m2ssgvhy3ppf5a3s0rf7mf4rq00c5ifchk URL
    http://beta.quicklisp.org/archive/yason/2016-02-08/yason-v0.7.6.tgz MD5 79de5d242c5e9ce49dfda153d5f442ec NAME yason TESTNAME NIL FILENAME yason DEPS
    ((NAME alexandria FILENAME alexandria) (NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES (alexandria trivial-gray-streams) VERSION
    v0.7.6 SIBLINGS NIL) */
