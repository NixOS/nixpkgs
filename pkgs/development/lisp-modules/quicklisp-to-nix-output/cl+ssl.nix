args @ { fetchurl, ... }:
rec {
  baseName = ''cl+ssl'';
  version = ''cl+ssl-20161208-git'';

  description = ''Common Lisp interface to OpenSSL.'';

  deps = [ args."uiop" args."trivial-gray-streams" args."trivial-garbage" args."flexi-streams" args."cffi" args."bordeaux-threads" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl+ssl/2016-12-08/cl+ssl-20161208-git.tgz'';
    sha256 = ''0x9xa2rdfh9gxp5m27cj0wvzjqccz4w5cvm7nbk5shwsz5xgr7hs'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl+ssl[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256 0x9xa2rdfh9gxp5m27cj0wvzjqccz4w5cvm7nbk5shwsz5xgr7hs URL
    http://beta.quicklisp.org/archive/cl+ssl/2016-12-08/cl+ssl-20161208-git.tgz MD5 8050639e66800045cb0a43863059e630 NAME cl+ssl TESTNAME NIL FILENAME cl+ssl
    DEPS ((NAME uiop) (NAME trivial-gray-streams) (NAME trivial-garbage) (NAME flexi-streams) (NAME cffi) (NAME bordeaux-threads)) DEPENDENCIES
    (uiop trivial-gray-streams trivial-garbage flexi-streams cffi bordeaux-threads) VERSION cl+ssl-20161208-git SIBLINGS (cl+ssl.test)) */
