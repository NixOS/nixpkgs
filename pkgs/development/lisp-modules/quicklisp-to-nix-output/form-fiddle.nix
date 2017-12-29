args @ { fetchurl, ... }:
rec {
  baseName = ''form-fiddle'';
  version = ''20170630-git'';

  description = ''A collection of utilities to destructure lambda forms.'';

  deps = [ args."documentation-utils" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/form-fiddle/2017-06-30/form-fiddle-20170630-git.tgz'';
    sha256 = ''0w4isi9y2h6vswq418hj50223aac89iadl71y86wxdlznm3kdvjf'';
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
/* (SYSTEM form-fiddle DESCRIPTION A collection of utilities to destructure lambda forms. SHA256 0w4isi9y2h6vswq418hj50223aac89iadl71y86wxdlznm3kdvjf URL
    http://beta.quicklisp.org/archive/form-fiddle/2017-06-30/form-fiddle-20170630-git.tgz MD5 9c8eb18dfedebcf43718cc259c910aa1 NAME form-fiddle TESTNAME NIL
    FILENAME form-fiddle DEPS ((NAME documentation-utils FILENAME documentation-utils)) DEPENDENCIES (documentation-utils) VERSION 20170630-git SIBLINGS NIL) */
