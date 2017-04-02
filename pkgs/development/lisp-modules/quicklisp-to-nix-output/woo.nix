args @ { fetchurl, ... }:
rec {
  baseName = ''woo'';
  version = ''20170227-git'';

  description = ''An asynchronous HTTP server written in Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/woo/2017-02-27/woo-20170227-git.tgz'';
    sha256 = ''0myydz817mpkgs97p9y9n4z0kq00xxr2b65klsdkxasvvfyjw0d1'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/woo[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM woo DESCRIPTION An asynchronous HTTP server written in Common Lisp SHA256 0myydz817mpkgs97p9y9n4z0kq00xxr2b65klsdkxasvvfyjw0d1 URL
    http://beta.quicklisp.org/archive/woo/2017-02-27/woo-20170227-git.tgz MD5 cc37270ad408e093bd28c025466d8f64 NAME woo TESTNAME NIL FILENAME woo DEPS NIL
    DEPENDENCIES NIL VERSION 20170227-git SIBLINGS (clack-handler-woo woo-test)) */
