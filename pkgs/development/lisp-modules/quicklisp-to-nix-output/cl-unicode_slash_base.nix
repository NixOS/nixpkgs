args @ { fetchurl, ... }:
rec {
  baseName = ''cl-unicode_slash_base'';
  version = ''cl-unicode-0.1.5'';

  description = '''';

  deps = [ args."cl-ppcre" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-unicode/2014-12-17/cl-unicode-0.1.5.tgz'';
    sha256 = ''1jd5qq5ji6l749c4x415z22y9r0k9z18pdi9p9fqvamzh854i46n'';
  };
    
  packageName = "cl-unicode/base";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-unicode/base[.]asd${"$"}' |
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
/* (SYSTEM cl-unicode/base DESCRIPTION NIL SHA256 1jd5qq5ji6l749c4x415z22y9r0k9z18pdi9p9fqvamzh854i46n URL
    http://beta.quicklisp.org/archive/cl-unicode/2014-12-17/cl-unicode-0.1.5.tgz MD5 2fd456537bd670126da84466226bc5c5 NAME cl-unicode/base TESTNAME NIL
    FILENAME cl-unicode_slash_base DEPS ((NAME cl-ppcre FILENAME cl-ppcre)) DEPENDENCIES (cl-ppcre) VERSION cl-unicode-0.1.5 SIBLINGS (cl-unicode)) */
