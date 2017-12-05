args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-indent'';
  version = ''20170630-git'';

  description = ''A very simple library to allow indentation hints for SWANK.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-indent/2017-06-30/trivial-indent-20170630-git.tgz'';
    sha256 = ''18zag7n2yfjx3x6nm8132cq8lz321i3f3zslb90j198wvpwyrnq7'';
  };
    
  packageName = "trivial-indent";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/trivial-indent[.]asd${"$"}' |
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
/* (SYSTEM trivial-indent DESCRIPTION A very simple library to allow indentation hints for SWANK. SHA256 18zag7n2yfjx3x6nm8132cq8lz321i3f3zslb90j198wvpwyrnq7
    URL http://beta.quicklisp.org/archive/trivial-indent/2017-06-30/trivial-indent-20170630-git.tgz MD5 9f11cc1014be3e3ae588a3cd07315be6 NAME trivial-indent
    TESTNAME NIL FILENAME trivial-indent DEPS NIL DEPENDENCIES NIL VERSION 20170630-git SIBLINGS NIL) */
