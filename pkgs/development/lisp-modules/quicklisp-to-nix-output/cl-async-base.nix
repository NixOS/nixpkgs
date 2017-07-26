args @ { fetchurl, ... }:
rec {
  baseName = ''cl-async-base'';
  version = ''cl-async-20160825-git'';

  testSystems = ["cl-async"];

  description = ''Base system for cl-async.'';

  deps = [ args."cl-libuv" args."cffi" args."bordeaux-threads" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz'';
    sha256 = ''104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa'';
  };
    
  packageName = "cl-async-base";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-async-base[.]asd${"$"}' |
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
/* (SYSTEM cl-async-base DESCRIPTION Base system for cl-async. SHA256 104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa URL
    http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz MD5 18e1d6c54a27c8ba721ebaa3d8c6e112 NAME cl-async-base TESTNAME cl-async
    FILENAME cl-async-base DEPS ((NAME cl-libuv FILENAME cl-libuv) (NAME cffi FILENAME cffi) (NAME bordeaux-threads FILENAME bordeaux-threads)) DEPENDENCIES
    (cl-libuv cffi bordeaux-threads) VERSION cl-async-20160825-git SIBLINGS (cl-async-repl cl-async-ssl cl-async-test cl-async)) */
