args @ { fetchurl, ... }:
rec {
  baseName = ''plump'';
  version = ''20170725-git'';

  description = ''An XML / XHTML / HTML parser that aims to be as lenient as possible.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2017-07-25/plump-20170725-git.tgz'';
    sha256 = ''118ashy1sqi666k18fqjkkzzqcak1f1aq93vm2hiadbdvrwn9s72'';
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
/* (SYSTEM plump DESCRIPTION An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256 118ashy1sqi666k18fqjkkzzqcak1f1aq93vm2hiadbdvrwn9s72
    URL http://beta.quicklisp.org/archive/plump/2017-07-25/plump-20170725-git.tgz MD5 e5e92dd177711a14753ee86961710458 NAME plump TESTNAME NIL FILENAME plump
    DEPS NIL DEPENDENCIES NIL VERSION 20170725-git SIBLINGS (plump-dom plump-lexer plump-parser)) */
