args @ { fetchurl, ... }:
rec {
  baseName = ''cl-async-repl'';
  version = ''cl-async-20160825-git'';

  description = ''REPL integration for CL-ASYNC.'';

  deps = [ args."bordeaux-threads" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz'';
    sha256 = ''104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-async-repl[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-async-repl DESCRIPTION REPL integration for CL-ASYNC. SHA256 104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa URL
    http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz MD5 18e1d6c54a27c8ba721ebaa3d8c6e112 NAME cl-async-repl TESTNAME NIL
    FILENAME cl-async-repl DEPS ((NAME bordeaux-threads)) DEPENDENCIES (bordeaux-threads) VERSION cl-async-20160825-git SIBLINGS
    (cl-async-ssl cl-async-test cl-async)) */
