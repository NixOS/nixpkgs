args @ { fetchurl, ... }:
rec {
  baseName = ''rfc2388'';
  version = ''20130720-git'';

  description = ''Implementation of RFC 2388'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/rfc2388/2013-07-20/rfc2388-20130720-git.tgz'';
    sha256 = ''1ky99cr4bgfyh0pfpl5f6fsmq1qdbgi4b8v0cfs4y73f78p1f8b6'';
  };
    
  packageName = "rfc2388";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/rfc2388[.]asd${"$"}' |
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
/* (SYSTEM rfc2388 DESCRIPTION Implementation of RFC 2388 SHA256 1ky99cr4bgfyh0pfpl5f6fsmq1qdbgi4b8v0cfs4y73f78p1f8b6 URL
    http://beta.quicklisp.org/archive/rfc2388/2013-07-20/rfc2388-20130720-git.tgz MD5 10a8bfea588196b1147d5dc7bf759bb1 NAME rfc2388 TESTNAME NIL FILENAME
    rfc2388 DEPS NIL DEPENDENCIES NIL VERSION 20130720-git SIBLINGS NIL) */
