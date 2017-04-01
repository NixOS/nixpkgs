args @ { fetchurl, ... }:
rec {
  baseName = ''array-utils'';
  version = ''20160929-git'';

  description = ''A few utilities for working with arrays.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/array-utils/2016-09-29/array-utils-20160929-git.tgz'';
    sha256 = ''1nlrf7b81qq7l85kkdh3fxcs6ngnvh5zk7mb5mwf8vjm5kpfbbcx'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/array-utils[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM array-utils DESCRIPTION A few utilities for working with arrays. SHA256 1nlrf7b81qq7l85kkdh3fxcs6ngnvh5zk7mb5mwf8vjm5kpfbbcx URL
    http://beta.quicklisp.org/archive/array-utils/2016-09-29/array-utils-20160929-git.tgz MD5 8b3880c7b73625cf8ed599d91a3836b4 NAME array-utils TESTNAME NIL
    FILENAME array-utils DEPS NIL DEPENDENCIES NIL VERSION 20160929-git SIBLINGS (array-utils-test)) */
