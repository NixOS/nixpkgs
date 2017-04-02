args @ { fetchurl, ... }:
rec {
  baseName = ''uiop'';
  version = ''3.2.0'';

  description = ''Portability library for Common Lisp programs'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uiop/2017-01-24/uiop-3.2.0.tgz'';
    sha256 = ''1rrn1mdcb4dmb517vrp3nzwpp1w8hfvpzarj36c7kkpjq23czdig'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/uiop[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM uiop DESCRIPTION Portability library for Common Lisp programs SHA256 1rrn1mdcb4dmb517vrp3nzwpp1w8hfvpzarj36c7kkpjq23czdig URL
    http://beta.quicklisp.org/archive/uiop/2017-01-24/uiop-3.2.0.tgz MD5 3c304efce790959b14a241db2e669fce NAME uiop TESTNAME NIL FILENAME uiop DEPS NIL
    DEPENDENCIES NIL VERSION 3.2.0 SIBLINGS (asdf-driver)) */
