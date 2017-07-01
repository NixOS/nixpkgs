args @ { fetchurl, ... }:
rec {
  baseName = ''esrap'';
  version = ''20170516-git'';

  description = ''A Packrat / Parsing Grammar / TDPL parser for Common Lisp.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/esrap/2017-05-16/esrap-20170516-git.tgz'';
    sha256 = ''06vksigkiprhmxkms2xfwq8ff09z4i4287k87n0m4id0nfl8rfq8'';
  };
    
  packageName = "esrap";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/esrap[.]asd${"$"}' |
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
/* (SYSTEM esrap DESCRIPTION A Packrat / Parsing Grammar / TDPL parser for Common Lisp. SHA256 06vksigkiprhmxkms2xfwq8ff09z4i4287k87n0m4id0nfl8rfq8 URL
    http://beta.quicklisp.org/archive/esrap/2017-05-16/esrap-20170516-git.tgz MD5 6116df281050ee58e6ba195727154ac0 NAME esrap TESTNAME NIL FILENAME esrap DEPS
    NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS NIL) */
