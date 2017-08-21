args @ { fetchurl, ... }:
rec {
  baseName = ''static-vectors'';
  version = ''v1.8.2'';

  description = ''Create vectors allocated in static memory.'';

  deps = [ args."alexandria" args."cffi" args."cffi-grovel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/static-vectors/2017-01-24/static-vectors-v1.8.2.tgz'';
    sha256 = ''0p35f0wrnv46bmmxlviwpsbxnlnkmxwd3xp858lhf0dy52cyra1g'';
  };
    
  packageName = "static-vectors";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/static-vectors[.]asd${"$"}' |
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
/* (SYSTEM static-vectors DESCRIPTION Create vectors allocated in static memory. SHA256 0p35f0wrnv46bmmxlviwpsbxnlnkmxwd3xp858lhf0dy52cyra1g URL
    http://beta.quicklisp.org/archive/static-vectors/2017-01-24/static-vectors-v1.8.2.tgz MD5 fd3ebe4e79a71c49e32ac87d6a1bcaf4 NAME static-vectors TESTNAME NIL
    FILENAME static-vectors DEPS ((NAME alexandria FILENAME alexandria) (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)) DEPENDENCIES
    (alexandria cffi cffi-grovel) VERSION v1.8.2 SIBLINGS NIL) */
