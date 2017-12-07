args @ { fetchurl, ... }:
rec {
  baseName = ''fast-io'';
  version = ''20170630-git'';

  description = ''Alternative I/O mechanism to a stream or vector'';

  deps = [ args."trivial-gray-streams" args."static-vectors" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-io/2017-06-30/fast-io-20170630-git.tgz'';
    sha256 = ''0wg40jv6hn4ijks026d2aaz5pr3zfxxzaakyzzjka6981g9rgkrg'';
  };
    
  packageName = "fast-io";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/fast-io[.]asd${"$"}' |
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
/* (SYSTEM fast-io DESCRIPTION Alternative I/O mechanism to a stream or vector SHA256 0wg40jv6hn4ijks026d2aaz5pr3zfxxzaakyzzjka6981g9rgkrg URL
    http://beta.quicklisp.org/archive/fast-io/2017-06-30/fast-io-20170630-git.tgz MD5 34bfe5f306f2e0f6da128fe024ee242d NAME fast-io TESTNAME NIL FILENAME
    fast-io DEPS
    ((NAME trivial-gray-streams FILENAME trivial-gray-streams) (NAME static-vectors FILENAME static-vectors) (NAME alexandria FILENAME alexandria))
    DEPENDENCIES (trivial-gray-streams static-vectors alexandria) VERSION 20170630-git SIBLINGS (fast-io-test)) */
