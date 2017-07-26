args @ { fetchurl, ... }:
rec {
  baseName = ''jonathan'';
  version = ''20170516-git'';

  description = ''High performance JSON encoder and decoder. Currently support: SBCL, CCL.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/jonathan/2017-05-16/jonathan-20170516-git.tgz'';
    sha256 = ''00bpmarfhcms2nnghyhh02ci9rjpjvzlmy2fdvlybfmv9d48lq3q'';
  };
    
  packageName = "jonathan";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/jonathan[.]asd${"$"}' |
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
/* (SYSTEM jonathan DESCRIPTION High performance JSON encoder and decoder. Currently support: SBCL, CCL. SHA256
    00bpmarfhcms2nnghyhh02ci9rjpjvzlmy2fdvlybfmv9d48lq3q URL http://beta.quicklisp.org/archive/jonathan/2017-05-16/jonathan-20170516-git.tgz MD5
    b05ccc0140e70636240f216fdc14e4d3 NAME jonathan TESTNAME NIL FILENAME jonathan DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS (jonathan-test)) */
