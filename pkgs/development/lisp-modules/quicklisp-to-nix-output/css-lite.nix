args @ { fetchurl, ... }:
rec {
  baseName = ''css-lite'';
  version = ''20120407-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/css-lite/2012-04-07/css-lite-20120407-git.tgz'';
    sha256 = ''1gf1qqaxhly6ixh9ykqhg9b52s8p5wlwi46vp2k29qy7gmx4f1qg'';
  };
    
  packageName = "css-lite";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/css-lite[.]asd${"$"}' |
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
/* (SYSTEM css-lite DESCRIPTION NIL SHA256 1gf1qqaxhly6ixh9ykqhg9b52s8p5wlwi46vp2k29qy7gmx4f1qg URL
    http://beta.quicklisp.org/archive/css-lite/2012-04-07/css-lite-20120407-git.tgz MD5 9b25afb0d2c3f0c32d2303ab1d3f570d NAME css-lite TESTNAME NIL FILENAME
    css-lite DEPS NIL DEPENDENCIES NIL VERSION 20120407-git SIBLINGS NIL) */
