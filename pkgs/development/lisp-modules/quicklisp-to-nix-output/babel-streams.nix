args @ { fetchurl, ... }:
rec {
  baseName = ''babel-streams'';
  version = ''babel-20170516-git'';

  description = ''Some useful streams based on Babel's encoding code'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/babel/2017-05-16/babel-20170516-git.tgz'';
    sha256 = ''0igl7vgbbpil8ksfsmj1055m6jcpmvf149zmmzsxr9h608siy7fk'';
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
/* (SYSTEM babel-streams DESCRIPTION Some useful streams based on Babel's encoding code SHA256 0igl7vgbbpil8ksfsmj1055m6jcpmvf149zmmzsxr9h608siy7fk URL
    http://beta.quicklisp.org/archive/babel/2017-05-16/babel-20170516-git.tgz MD5 d2ab5a273a436375ba40a8ec7f38d0a9 NAME babel-streams TESTNAME NIL FILENAME
    babel-streams DEPS NIL DEPENDENCIES NIL VERSION babel-20170516-git SIBLINGS (babel-tests babel)) */
