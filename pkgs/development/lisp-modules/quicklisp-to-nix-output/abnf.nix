args @ { fetchurl, ... }:
rec {
  baseName = ''abnf'';
  version = ''cl-20150608-git'';

  description = ''ABNF Parser Generator, per RFC2234'';

  deps = [ args."cl-ppcre" args."esrap" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-abnf/2015-06-08/cl-abnf-20150608-git.tgz'';
    sha256 = ''00x95h7v5q7azvr9wrpcfcwsq3sdipjr1hgq9a9lbimp8gfbz687'';
  };
    
  packageName = "abnf";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/abnf[.]asd${"$"}' |
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
/* (SYSTEM abnf DESCRIPTION ABNF Parser Generator, per RFC2234 SHA256 00x95h7v5q7azvr9wrpcfcwsq3sdipjr1hgq9a9lbimp8gfbz687 URL
    http://beta.quicklisp.org/archive/cl-abnf/2015-06-08/cl-abnf-20150608-git.tgz MD5 311c2b17e49666dac1c2bb45256be708 NAME abnf TESTNAME NIL FILENAME abnf
    DEPS ((NAME cl-ppcre FILENAME cl-ppcre) (NAME esrap FILENAME esrap)) DEPENDENCIES (cl-ppcre esrap) VERSION cl-20150608-git SIBLINGS NIL) */
