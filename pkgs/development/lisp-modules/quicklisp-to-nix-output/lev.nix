args @ { fetchurl, ... }:
rec {
  baseName = ''lev'';
  version = ''20150505-git'';

  description = ''libev bindings for Common Lisp'';

  deps = [ args."cffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lev/2015-05-05/lev-20150505-git.tgz'';
    sha256 = ''0lkkzb221ks4f0qjgh6pr5lyvb4884a87p96ir4m36x411pyk5xl'';
  };
    
  packageName = "lev";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/lev[.]asd${"$"}' |
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
/* (SYSTEM lev DESCRIPTION libev bindings for Common Lisp SHA256 0lkkzb221ks4f0qjgh6pr5lyvb4884a87p96ir4m36x411pyk5xl URL
    http://beta.quicklisp.org/archive/lev/2015-05-05/lev-20150505-git.tgz MD5 10f340f7500beb98b5c0d4a9876131fb NAME lev TESTNAME NIL FILENAME lev DEPS
    ((NAME cffi FILENAME cffi)) DEPENDENCIES (cffi) VERSION 20150505-git SIBLINGS NIL) */
