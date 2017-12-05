args @ { fetchurl, ... }:
rec {
  baseName = ''babel'';
  version = ''20170630-git'';

  description = ''Babel, a charset conversion library.'';

  deps = [ args."trivial-features" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2017-06-30/babel-20170630-git.tgz'';
    sha256 = ''0w1jfzdklk5zz9vgplr2a0vc6gybrwl8wa72nj6xs4ihp7spf0lx'';
  };
    
  packageName = "babel";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/babel[.]asd${"$"}' |
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
/* (SYSTEM babel DESCRIPTION Babel, a charset conversion library. SHA256 0w1jfzdklk5zz9vgplr2a0vc6gybrwl8wa72nj6xs4ihp7spf0lx URL
    http://beta.quicklisp.org/archive/babel/2017-06-30/babel-20170630-git.tgz MD5 aa7eff848b97bb7f7aa6bdb43a081964 NAME babel TESTNAME NIL FILENAME babel DEPS
    ((NAME trivial-features FILENAME trivial-features) (NAME alexandria FILENAME alexandria)) DEPENDENCIES (trivial-features alexandria) VERSION 20170630-git
    SIBLINGS (babel-streams babel-tests)) */
