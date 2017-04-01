args @ { fetchurl, ... }:
rec {
  baseName = ''cl-async-ssl'';
  version = ''cl-async-20160825-git'';

  description = ''SSL Wrapper around cl-async socket implementation.'';

  deps = [ args."vom" args."cffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz'';
    sha256 = ''104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-async-ssl[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-async-ssl DESCRIPTION SSL Wrapper around cl-async socket implementation. SHA256 104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa URL
    http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz MD5 18e1d6c54a27c8ba721ebaa3d8c6e112 NAME cl-async-ssl TESTNAME NIL
    FILENAME cl-async-ssl DEPS ((NAME vom) (NAME cffi)) DEPENDENCIES (vom cffi) VERSION cl-async-20160825-git SIBLINGS (cl-async-repl cl-async-test cl-async)) */
