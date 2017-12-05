args @ { fetchurl, ... }:
rec {
  baseName = ''garbage-pools'';
  version = ''20130720-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/garbage-pools/2013-07-20/garbage-pools-20130720-git.tgz'';
    sha256 = ''1idnba1pxayn0k5yzqp9lswg7ywjhavi59lrdnphfqajjpyi9w05'';
  };
    
  packageName = "garbage-pools";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/garbage-pools[.]asd${"$"}' |
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
/* (SYSTEM garbage-pools DESCRIPTION NIL SHA256 1idnba1pxayn0k5yzqp9lswg7ywjhavi59lrdnphfqajjpyi9w05 URL
    http://beta.quicklisp.org/archive/garbage-pools/2013-07-20/garbage-pools-20130720-git.tgz MD5 f691e2ddf6ba22b3451c24b61d4ee8b6 NAME garbage-pools TESTNAME
    NIL FILENAME garbage-pools DEPS NIL DEPENDENCIES NIL VERSION 20130720-git SIBLINGS (garbage-pools-test)) */
