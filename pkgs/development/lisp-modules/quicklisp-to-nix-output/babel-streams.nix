args @ { fetchurl, ... }:
rec {
  baseName = ''babel-streams'';
  version = ''babel-20170630-git'';

  description = ''Some useful streams based on Babel's encoding code'';

  deps = [ args."trivial-gray-streams" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2017-06-30/babel-20170630-git.tgz'';
    sha256 = ''0w1jfzdklk5zz9vgplr2a0vc6gybrwl8wa72nj6xs4ihp7spf0lx'';
  };
    
  packageName = "babel-streams";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/babel-streams[.]asd${"$"}' |
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
/* (SYSTEM babel-streams DESCRIPTION Some useful streams based on Babel's encoding code SHA256 0w1jfzdklk5zz9vgplr2a0vc6gybrwl8wa72nj6xs4ihp7spf0lx URL
    http://beta.quicklisp.org/archive/babel/2017-06-30/babel-20170630-git.tgz MD5 aa7eff848b97bb7f7aa6bdb43a081964 NAME babel-streams TESTNAME NIL FILENAME
    babel-streams DEPS ((NAME trivial-gray-streams FILENAME trivial-gray-streams) (NAME alexandria FILENAME alexandria)) DEPENDENCIES
    (trivial-gray-streams alexandria) VERSION babel-20170630-git SIBLINGS (babel-tests babel)) */
