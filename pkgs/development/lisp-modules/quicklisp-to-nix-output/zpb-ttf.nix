args @ { fetchurl, ... }:
rec {
  baseName = ''zpb-ttf'';
  version = ''1.0.3'';

  description = ''Access TrueType font metrics and outlines from Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/zpb-ttf/2013-07-20/zpb-ttf-1.0.3.tgz'';
    sha256 = ''1irv0d0pcbwi2wx6hhjjyxzw12lnw8pvyg6ljsljh8xmhppbg5j6'';
  };
    
  packageName = "zpb-ttf";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/zpb-ttf[.]asd${"$"}' |
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
/* (SYSTEM zpb-ttf DESCRIPTION Access TrueType font metrics and outlines from Common Lisp SHA256 1irv0d0pcbwi2wx6hhjjyxzw12lnw8pvyg6ljsljh8xmhppbg5j6 URL
    http://beta.quicklisp.org/archive/zpb-ttf/2013-07-20/zpb-ttf-1.0.3.tgz MD5 1e896d8b0b01babab882e43fe4c3c2d4 NAME zpb-ttf TESTNAME NIL FILENAME zpb-ttf DEPS
    NIL DEPENDENCIES NIL VERSION 1.0.3 SIBLINGS NIL) */
