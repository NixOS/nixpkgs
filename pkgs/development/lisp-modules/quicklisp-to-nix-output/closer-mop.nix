args @ { fetchurl, ... }:
rec {
  baseName = ''closer-mop'';
  version = ''20170403-git'';

  description = ''Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closer-mop/2017-04-03/closer-mop-20170403-git.tgz'';
    sha256 = ''166k9r55zf0lyvdacvih5y63xv2kp0kqmx9z6jmkyb3snrdghijf'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/closer-mop[.]asd${"$"}' |
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
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 166k9r55zf0lyvdacvih5y63xv2kp0kqmx9z6jmkyb3snrdghijf URL http://beta.quicklisp.org/archive/closer-mop/2017-04-03/closer-mop-20170403-git.tgz MD5
    806918d9975d0c82fc471f95f40972a1 NAME closer-mop TESTNAME NIL FILENAME closer-mop DEPS NIL DEPENDENCIES NIL VERSION 20170403-git SIBLINGS NIL) */
