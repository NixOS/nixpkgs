args @ { fetchurl, ... }:
rec {
  baseName = ''idna'';
  version = ''20120107-git'';

  description = ''IDNA (international domain names) string encoding and decoding routines'';

  deps = [ args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/idna/2012-01-07/idna-20120107-git.tgz'';
    sha256 = ''0q9hja9v5q7z89p0bzm2whchn05hymn3255fr5zj3fkja8akma5c'';
  };
    
  packageName = "idna";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/idna[.]asd${"$"}' |
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
/* (SYSTEM idna DESCRIPTION IDNA (international domain names) string encoding and decoding routines SHA256 0q9hja9v5q7z89p0bzm2whchn05hymn3255fr5zj3fkja8akma5c
    URL http://beta.quicklisp.org/archive/idna/2012-01-07/idna-20120107-git.tgz MD5 85b91a66efe4381bf116cdb5d2b756b6 NAME idna TESTNAME NIL FILENAME idna DEPS
    ((NAME split-sequence FILENAME split-sequence)) DEPENDENCIES (split-sequence) VERSION 20120107-git SIBLINGS NIL) */
