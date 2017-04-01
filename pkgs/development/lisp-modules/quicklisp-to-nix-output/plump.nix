args @ { fetchurl, ... }:
rec {
  baseName = ''plump'';
  version = ''20170124-git'';

  description = ''An XML / XHTML / HTML parser that aims to be as lenient as possible.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/plump/2017-01-24/plump-20170124-git.tgz'';
    sha256 = ''1swl5kr6hgl7hkybixsx7h4ddc7c0a7pisgmmiz2bs2rv4inz69x'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/plump[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM plump DESCRIPTION An XML / XHTML / HTML parser that aims to be as lenient as possible. SHA256 1swl5kr6hgl7hkybixsx7h4ddc7c0a7pisgmmiz2bs2rv4inz69x
    URL http://beta.quicklisp.org/archive/plump/2017-01-24/plump-20170124-git.tgz MD5 c49aeb37173aca79ee6ff5c89b0c4b1a NAME plump TESTNAME NIL FILENAME plump
    DEPS NIL DEPENDENCIES NIL VERSION 20170124-git SIBLINGS (plump-dom plump-lexer plump-parser)) */
