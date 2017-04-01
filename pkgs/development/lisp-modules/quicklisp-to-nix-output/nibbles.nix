args @ { fetchurl, ... }:
rec {
  baseName = ''nibbles'';
  version = ''20161204-git'';

  description = ''A library for accessing octet-addressed blocks of data in big- and little-endian orders'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/nibbles/2016-12-04/nibbles-20161204-git.tgz'';
    sha256 = ''06cdnivq2966crpj8pidqmwagaif848yvq4fjqq213f3wynwknh4'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/nibbles[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM nibbles DESCRIPTION A library for accessing octet-addressed blocks of data in big- and little-endian orders SHA256
    06cdnivq2966crpj8pidqmwagaif848yvq4fjqq213f3wynwknh4 URL http://beta.quicklisp.org/archive/nibbles/2016-12-04/nibbles-20161204-git.tgz MD5
    a342eb0426be2570c18151ef8742dad3 NAME nibbles TESTNAME NIL FILENAME nibbles DEPS NIL DEPENDENCIES NIL VERSION 20161204-git SIBLINGS NIL) */
