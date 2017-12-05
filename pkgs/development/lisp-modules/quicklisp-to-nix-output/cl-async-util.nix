args @ { fetchurl, ... }:
rec {
  baseName = ''cl-async-util'';
  version = ''cl-async-20160825-git'';

  description = ''Internal utilities for cl-async.'';

  deps = [ args."vom" args."fast-io" args."cl-ppcre" args."cl-libuv" args."cl-async-base" args."cffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz'';
    sha256 = ''104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa'';
  };
    
  packageName = "cl-async-util";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-async-util[.]asd${"$"}' |
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
/* (SYSTEM cl-async-util DESCRIPTION Internal utilities for cl-async. SHA256 104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa URL
    http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz MD5 18e1d6c54a27c8ba721ebaa3d8c6e112 NAME cl-async-util TESTNAME NIL
    FILENAME cl-async-util DEPS
    ((NAME vom FILENAME vom) (NAME fast-io FILENAME fast-io) (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-libuv FILENAME cl-libuv)
     (NAME cl-async-base FILENAME cl-async-base) (NAME cffi FILENAME cffi))
    DEPENDENCIES (vom fast-io cl-ppcre cl-libuv cl-async-base cffi) VERSION cl-async-20160825-git SIBLINGS (cl-async-repl cl-async-ssl cl-async-test cl-async)) */
