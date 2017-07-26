args @ { fetchurl, ... }:
rec {
  baseName = ''array-utils'';
  version = ''20170516-git'';

  description = ''A few utilities for working with arrays.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/array-utils/2017-05-16/array-utils-20170516-git.tgz'';
    sha256 = ''0mbzv2w0jkd175bl2flrkg1108f32hir5fl1n4x6cn8kc14af13q'';
  };
    
  packageName = "array-utils";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/array-utils[.]asd${"$"}' |
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
/* (SYSTEM array-utils DESCRIPTION A few utilities for working with arrays. SHA256 0mbzv2w0jkd175bl2flrkg1108f32hir5fl1n4x6cn8kc14af13q URL
    http://beta.quicklisp.org/archive/array-utils/2017-05-16/array-utils-20170516-git.tgz MD5 c6e4ccbee8f5d72fb86493b419cd0f59 NAME array-utils TESTNAME NIL
    FILENAME array-utils DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS (array-utils-test)) */
