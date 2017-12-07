args @ { fetchurl, ... }:
rec {
  baseName = ''iterate'';
  version = ''20160825-darcs'';

  description = ''Jonathan Amsterdam's iterator/gatherer/accumulator facility'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iterate/2016-08-25/iterate-20160825-darcs.tgz'';
    sha256 = ''0kvz16gnxnkdz0fy1x8y5yr28nfm7i2qpvix7mgwccdpjmsb4pgm'';
  };
    
  packageName = "iterate";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/iterate[.]asd${"$"}' |
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
/* (SYSTEM iterate DESCRIPTION Jonathan Amsterdam's iterator/gatherer/accumulator facility SHA256 0kvz16gnxnkdz0fy1x8y5yr28nfm7i2qpvix7mgwccdpjmsb4pgm URL
    http://beta.quicklisp.org/archive/iterate/2016-08-25/iterate-20160825-darcs.tgz MD5 e73ff4898ce4831ff2a28817f32de86e NAME iterate TESTNAME NIL FILENAME
    iterate DEPS NIL DEPENDENCIES NIL VERSION 20160825-darcs SIBLINGS NIL) */
