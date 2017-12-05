args @ { fetchurl, ... }:
rec {
  baseName = ''clss'';
  version = ''20170630-git'';

  description = ''A DOM tree searching engine based on CSS selectors.'';

  deps = [ args."array-utils" args."plump" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clss/2017-06-30/clss-20170630-git.tgz'';
    sha256 = ''0kdkzx7z997lzbf331p4fkqhri0ind7agknl9y992x917m9y4rn0'';
  };
    
  packageName = "clss";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clss[.]asd${"$"}' |
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
/* (SYSTEM clss DESCRIPTION A DOM tree searching engine based on CSS selectors. SHA256 0kdkzx7z997lzbf331p4fkqhri0ind7agknl9y992x917m9y4rn0 URL
    http://beta.quicklisp.org/archive/clss/2017-06-30/clss-20170630-git.tgz MD5 61bbadf22391940813bfc66dfd59d304 NAME clss TESTNAME NIL FILENAME clss DEPS
    ((NAME array-utils FILENAME array-utils) (NAME plump FILENAME plump)) DEPENDENCIES (array-utils plump) VERSION 20170630-git SIBLINGS NIL) */
