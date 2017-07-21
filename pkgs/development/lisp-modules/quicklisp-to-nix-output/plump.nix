args @ { fetchurl, ... }:
rec {
  baseName = ''plump'';
  version = ''20170516-git'';

  description = ''An XML / XHTML / HTML parser that aims to be as lenient as possible.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2017-05-16/plump-20170516-git.tgz'';
    sha256 = ''0i7fb1y4dfd7i97w33xf8d1ykza4irl89xkipainydigkk66xaz8'';
  };
    
  packageName = "plump";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/plump[.]asd${"$"}' |
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
/* (SYSTEM plump DESCRIPTION An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256 0i7fb1y4dfd7i97w33xf8d1ykza4irl89xkipainydigkk66xaz8
    URL http://beta.quicklisp.org/archive/plump/2017-05-16/plump-20170516-git.tgz MD5 917a4f25691b3087ce24fd52ee42b4be NAME plump TESTNAME NIL FILENAME plump
    DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS (plump-dom plump-lexer plump-parser)) */
