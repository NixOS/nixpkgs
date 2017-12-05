args @ { fetchurl, ... }:
rec {
  baseName = ''array-utils'';
  version = ''20170630-git'';

  description = ''A few utilities for working with arrays.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/array-utils/2017-06-30/array-utils-20170630-git.tgz'';
    sha256 = ''1nj42w2q11qdg65cviaj514pcql1gi729mcsj5g2vy17pr298zgb'';
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
/* (SYSTEM array-utils DESCRIPTION A few utilities for working with arrays. SHA256 1nj42w2q11qdg65cviaj514pcql1gi729mcsj5g2vy17pr298zgb URL
    http://beta.quicklisp.org/archive/array-utils/2017-06-30/array-utils-20170630-git.tgz MD5 550b37bc0eccfafa889de00b59c422dc NAME array-utils TESTNAME NIL
    FILENAME array-utils DEPS NIL DEPENDENCIES NIL VERSION 20170630-git SIBLINGS (array-utils-test)) */
