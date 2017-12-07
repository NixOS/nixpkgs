args @ { fetchurl, ... }:
rec {
  baseName = ''net_dot_didierverna_dot_asdf-flv'';
  version = ''asdf-flv-version-2.1'';

  description = ''ASDF extension to provide support for file-local variables.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/asdf-flv/2016-04-21/asdf-flv-version-2.1.tgz'';
    sha256 = ''12k0d4xyv6s9vy6gq18p8c9bm334jsfjly22lhg680kx2zr7y0lc'';
  };
    
  packageName = "net.didierverna.asdf-flv";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/net.didierverna.asdf-flv[.]asd${"$"}' |
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
/* (SYSTEM net.didierverna.asdf-flv DESCRIPTION ASDF extension to provide support for file-local variables. SHA256
    12k0d4xyv6s9vy6gq18p8c9bm334jsfjly22lhg680kx2zr7y0lc URL http://beta.quicklisp.org/archive/asdf-flv/2016-04-21/asdf-flv-version-2.1.tgz MD5
    2b74b721b7e5335d2230d6b95fc6be56 NAME net.didierverna.asdf-flv TESTNAME NIL FILENAME net_dot_didierverna_dot_asdf-flv DEPS NIL DEPENDENCIES NIL VERSION
    asdf-flv-version-2.1 SIBLINGS NIL) */
