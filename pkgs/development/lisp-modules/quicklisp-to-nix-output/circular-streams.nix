args @ { fetchurl, ... }:
rec {
  baseName = ''circular-streams'';
  version = ''20161204-git'';

  description = ''Circularly readable streams for Common Lisp'';

  deps = [ args."trivial-gray-streams" args."fast-io" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/circular-streams/2016-12-04/circular-streams-20161204-git.tgz'';
    sha256 = ''1i29b9sciqs5x59hlkdj2r4siyqgrwj5hb4lnc80jgfqvzbq4128'';
  };
    
  packageName = "circular-streams";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/circular-streams[.]asd${"$"}' |
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
/* (SYSTEM circular-streams DESCRIPTION Circularly readable streams for Common Lisp SHA256 1i29b9sciqs5x59hlkdj2r4siyqgrwj5hb4lnc80jgfqvzbq4128 URL
    http://beta.quicklisp.org/archive/circular-streams/2016-12-04/circular-streams-20161204-git.tgz MD5 2383f3b82fa3335d9106e1354a678db8 NAME circular-streams
    TESTNAME NIL FILENAME circular-streams DEPS ((NAME trivial-gray-streams FILENAME trivial-gray-streams) (NAME fast-io FILENAME fast-io)) DEPENDENCIES
    (trivial-gray-streams fast-io) VERSION 20161204-git SIBLINGS (circular-streams-test)) */
