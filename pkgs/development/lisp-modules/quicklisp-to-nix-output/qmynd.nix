args @ { fetchurl, ... }:
rec {
  baseName = ''qmynd'';
  version = ''20170630-git'';

  description = ''MySQL Native Driver'';

  deps = [ args."usocket" args."trivial-gray-streams" args."list-of" args."ironclad" args."flexi-streams" args."babel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/qmynd/2017-06-30/qmynd-20170630-git.tgz'';
    sha256 = ''01rg2rm4n19f5g39z2gdjcfy68z7ir51r44524vzzs0x9na9y6bi'';
  };
    
  packageName = "qmynd";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/qmynd[.]asd${"$"}' |
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
/* (SYSTEM qmynd DESCRIPTION MySQL Native Driver SHA256 01rg2rm4n19f5g39z2gdjcfy68z7ir51r44524vzzs0x9na9y6bi URL
    http://beta.quicklisp.org/archive/qmynd/2017-06-30/qmynd-20170630-git.tgz MD5 64776472d1e0c4c0e41a1b4a2a24167e NAME qmynd TESTNAME NIL FILENAME qmynd DEPS
    ((NAME usocket FILENAME usocket) (NAME trivial-gray-streams FILENAME trivial-gray-streams) (NAME list-of FILENAME list-of)
     (NAME ironclad FILENAME ironclad) (NAME flexi-streams FILENAME flexi-streams) (NAME babel FILENAME babel))
    DEPENDENCIES (usocket trivial-gray-streams list-of ironclad flexi-streams babel) VERSION 20170630-git SIBLINGS (qmynd-test)) */
