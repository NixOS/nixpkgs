args @ { fetchurl, ... }:
rec {
  baseName = ''salza2'';
  version = ''2.0.9'';

  description = ''Create compressed data in the ZLIB, DEFLATE, or GZIP
  data formats'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz'';
    sha256 = ''1m0hksgvq3njd9xa2nxlm161vgzw77djxmisq08v9pz2bz16v8va'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/salza2[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM salza2 DESCRIPTION Create compressed data in the ZLIB, DEFLATE, or GZIP
  data formats
    SHA256 1m0hksgvq3njd9xa2nxlm161vgzw77djxmisq08v9pz2bz16v8va URL http://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz MD5
    e62383de435081c0f1f888ec363bb32c NAME salza2 TESTNAME NIL FILENAME salza2 DEPS NIL DEPENDENCIES NIL VERSION 2.0.9 SIBLINGS NIL) */
