args @ { fetchurl, ... }:
rec {
  baseName = ''closer-mop'';
  version = ''20170227-git'';

  description = ''Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closer-mop/2017-02-27/closer-mop-20170227-git.tgz'';
    sha256 = ''1hdnbryh6gd8kn20yr5ldgkcs8i71c6awwf6a32nmp9l42gwv9k3'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/closer-mop[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM closer-mop DESCRIPTION
    Closer to MOP is a compatibility layer that rectifies many of the absent or incorrect CLOS MOP features across a broad range of Common Lisp implementations.
    SHA256 1hdnbryh6gd8kn20yr5ldgkcs8i71c6awwf6a32nmp9l42gwv9k3 URL http://beta.quicklisp.org/archive/closer-mop/2017-02-27/closer-mop-20170227-git.tgz MD5
    fb511369eb416a4cc8335db79d0ec4b2 NAME closer-mop TESTNAME NIL FILENAME closer-mop DEPS NIL DEPENDENCIES NIL VERSION 20170227-git SIBLINGS NIL) */
