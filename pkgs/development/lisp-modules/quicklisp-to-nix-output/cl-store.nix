args @ { fetchurl, ... }:
rec {
  baseName = ''cl-store'';
  version = ''20160531-git'';

  description = ''Serialization package'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-store/2016-05-31/cl-store-20160531-git.tgz'';
    sha256 = ''0j1pfgvzy6l7hb68xsz2dghsa94lip7caq6f6608jsqadmdswljz'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-store[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-store DESCRIPTION Serialization package SHA256 0j1pfgvzy6l7hb68xsz2dghsa94lip7caq6f6608jsqadmdswljz URL
    http://beta.quicklisp.org/archive/cl-store/2016-05-31/cl-store-20160531-git.tgz MD5 8b3f33956b05d8e900346663f6abca3c NAME cl-store TESTNAME NIL FILENAME
    cl-store DEPS NIL DEPENDENCIES NIL VERSION 20160531-git SIBLINGS NIL) */
