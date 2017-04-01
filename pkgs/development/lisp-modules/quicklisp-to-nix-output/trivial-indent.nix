args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-indent'';
  version = ''20160929-git'';

  description = ''A very simple library to allow indentation hints for SWANK.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-indent/2016-09-29/trivial-indent-20160929-git.tgz'';
    sha256 = ''0nc7d5xdx4h8jvvqif7f721z8296kl6jk5hqmgr0mj3g7svgfrir'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/trivial-indent[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM trivial-indent DESCRIPTION A very simple library to allow indentation hints for SWANK. SHA256 0nc7d5xdx4h8jvvqif7f721z8296kl6jk5hqmgr0mj3g7svgfrir
    URL http://beta.quicklisp.org/archive/trivial-indent/2016-09-29/trivial-indent-20160929-git.tgz MD5 d93c0fa8e29d7d37170efd58b84ac188 NAME trivial-indent
    TESTNAME NIL FILENAME trivial-indent DEPS NIL DEPENDENCIES NIL VERSION 20160929-git SIBLINGS NIL) */
