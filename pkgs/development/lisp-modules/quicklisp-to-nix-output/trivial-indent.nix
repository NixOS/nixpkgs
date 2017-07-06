args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-indent'';
  version = ''20170516-git'';

  description = ''A very simple library to allow indentation hints for SWANK.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-indent/2017-05-16/trivial-indent-20170516-git.tgz'';
    sha256 = ''0jvwmsn4z5sd2r1g3yml8mzra8pah5ly8n00p0sqqww61l9w06ma'';
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
/* (SYSTEM trivial-indent DESCRIPTION A very simple library to allow indentation hints for SWANK. SHA256 0jvwmsn4z5sd2r1g3yml8mzra8pah5ly8n00p0sqqww61l9w06ma
    URL http://beta.quicklisp.org/archive/trivial-indent/2017-05-16/trivial-indent-20170516-git.tgz MD5 6c8bde35ec010645c8d585c272ae01e8 NAME trivial-indent
    TESTNAME NIL FILENAME trivial-indent DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS NIL) */
