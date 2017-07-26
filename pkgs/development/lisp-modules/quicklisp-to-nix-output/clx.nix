args @ { fetchurl, ... }:
rec {
  baseName = ''clx'';
  version = ''20170516-git'';

  description = ''An implementation of the X Window System protocol in Lisp.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx/2017-05-16/clx-20170516-git.tgz'';
    sha256 = ''00lzm4m74bm5gvy6nss8ab735ddnijbsvimlrkx37sp9v3zln5gs'';
  };
    
  packageName = "clx";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clx[.]asd${"$"}' |
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
/* (SYSTEM clx DESCRIPTION An implementation of the X Window System protocol in Lisp. SHA256 00lzm4m74bm5gvy6nss8ab735ddnijbsvimlrkx37sp9v3zln5gs URL
    http://beta.quicklisp.org/archive/clx/2017-05-16/clx-20170516-git.tgz MD5 1f5d7963802a503d7f7fcf73e1f42dd8 NAME clx TESTNAME NIL FILENAME clx DEPS NIL
    DEPENDENCIES NIL VERSION 20170516-git SIBLINGS NIL) */
