args @ { fetchurl, ... }:
rec {
  baseName = ''db3'';
  version = ''cl-20150302-git'';

  description = ''DB3 file reader'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-db3/2015-03-02/cl-db3-20150302-git.tgz'';
    sha256 = ''0mwdpb7cdvxdcbyg3ags6xzwhblai170q3p20njs3v73s30dbzxi'';
  };
    
  packageName = "db3";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/db3[.]asd${"$"}' |
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
/* (SYSTEM db3 DESCRIPTION DB3 file reader SHA256 0mwdpb7cdvxdcbyg3ags6xzwhblai170q3p20njs3v73s30dbzxi URL
    http://beta.quicklisp.org/archive/cl-db3/2015-03-02/cl-db3-20150302-git.tgz MD5 578896a3f60f474742f240b703f8c5f5 NAME db3 TESTNAME NIL FILENAME db3 DEPS
    NIL DEPENDENCIES NIL VERSION cl-20150302-git SIBLINGS NIL) */
