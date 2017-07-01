args @ { fetchurl, ... }:
rec {
  baseName = ''documentation-utils'';
  version = ''20170516-git'';

  description = ''A few simple tools to help you with documenting your library.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/documentation-utils/2017-05-16/documentation-utils-20170516-git.tgz'';
    sha256 = ''0jb6sv85xx0vl8p9qrhfsvz130d4gw6hpgnvw1mx7skhi6zs82s1'';
  };
    
  packageName = "documentation-utils";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/documentation-utils[.]asd${"$"}' |
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
/* (SYSTEM documentation-utils DESCRIPTION A few simple tools to help you with documenting your library. SHA256
    0jb6sv85xx0vl8p9qrhfsvz130d4gw6hpgnvw1mx7skhi6zs82s1 URL
    http://beta.quicklisp.org/archive/documentation-utils/2017-05-16/documentation-utils-20170516-git.tgz MD5 5e04421eb7fd48d8abe1757b5211e310 NAME
    documentation-utils TESTNAME NIL FILENAME documentation-utils DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS NIL) */
