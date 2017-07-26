args @ { fetchurl, ... }:
rec {
  baseName = ''form-fiddle'';
  version = ''20170516-git'';

  description = ''A collection of utilities to destructure lambda forms.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/form-fiddle/2017-05-16/form-fiddle-20170516-git.tgz'';
    sha256 = ''00h38gh8absx9pclwlxgknbmbnj20sngkzaj2qa6whg5kgbgj4fh'';
  };
    
  packageName = "form-fiddle";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/form-fiddle[.]asd${"$"}' |
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
/* (SYSTEM form-fiddle DESCRIPTION A collection of utilities to destructure lambda forms. SHA256 00h38gh8absx9pclwlxgknbmbnj20sngkzaj2qa6whg5kgbgj4fh URL
    http://beta.quicklisp.org/archive/form-fiddle/2017-05-16/form-fiddle-20170516-git.tgz MD5 8f0d8b920f6da0c7fd939b7096c30235 NAME form-fiddle TESTNAME NIL
    FILENAME form-fiddle DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS NIL) */
