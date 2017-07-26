args @ { fetchurl, ... }:
rec {
  baseName = ''fast-io'';
  version = ''20170516-git'';

  description = ''Alternative I/O mechanism to a stream or vector'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-io/2017-05-16/fast-io-20170516-git.tgz'';
    sha256 = ''1aw7fjvd7bpq2fh99r48f81vhmqczn8f4jk33i9cgpx217gxigm1'';
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
/* (SYSTEM fast-io DESCRIPTION Alternative I/O mechanism to a stream or vector SHA256 1aw7fjvd7bpq2fh99r48f81vhmqczn8f4jk33i9cgpx217gxigm1 URL
    http://beta.quicklisp.org/archive/fast-io/2017-05-16/fast-io-20170516-git.tgz MD5 a9a96c0f6260271446fd43bf2e51e90f NAME fast-io TESTNAME NIL FILENAME
    fast-io DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS (fast-io-test)) */
