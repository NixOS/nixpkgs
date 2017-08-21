args @ { fetchurl, ... }:
rec {
  baseName = ''cl-async'';
  version = ''20160825-git'';

  description = ''Asynchronous operations for Common Lisp.'';

  deps = [ args."uiop" args."trivial-gray-streams" args."trivial-features" args."static-vectors" args."cl-ppcre" args."cl-libuv" args."cl-async-util" args."cl-async-base" args."cffi" args."babel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz'';
    sha256 = ''104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa'';
  };
    
  packageName = "cl-async";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-async[.]asd${"$"}' |
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
/* (SYSTEM cl-async DESCRIPTION Asynchronous operations for Common Lisp. SHA256 104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa URL
    http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz MD5 18e1d6c54a27c8ba721ebaa3d8c6e112 NAME cl-async TESTNAME NIL FILENAME
    cl-async DEPS
    ((NAME uiop FILENAME uiop) (NAME trivial-gray-streams FILENAME trivial-gray-streams) (NAME trivial-features FILENAME trivial-features)
     (NAME static-vectors FILENAME static-vectors) (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-libuv FILENAME cl-libuv)
     (NAME cl-async-util FILENAME cl-async-util) (NAME cl-async-base FILENAME cl-async-base) (NAME cffi FILENAME cffi) (NAME babel FILENAME babel))
    DEPENDENCIES (uiop trivial-gray-streams trivial-features static-vectors cl-ppcre cl-libuv cl-async-util cl-async-base cffi babel) VERSION 20160825-git
    SIBLINGS (cl-async-repl cl-async-ssl cl-async-test)) */
