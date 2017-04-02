args @ { fetchurl, ... }:
rec {
  baseName = ''clx-truetype'';
  version = ''20160825-git'';

  description = ''clx-truetype is pure common lisp solution for antialiased TrueType font rendering using CLX and XRender extension.'';

  deps = [ args."cl-aa" args."cl-fad" args."cl-paths-ttf" args."cl-store" args."cl-vectors" args."clx" args."trivial-features" args."zpb-ttf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx-truetype/2016-08-25/clx-truetype-20160825-git.tgz'';
    sha256 = ''0ndy067rg9w6636gxwlpnw7f3ck9nrnjb03444pprik9r3c9in67'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clx-truetype[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM clx-truetype DESCRIPTION clx-truetype is pure common lisp solution for antialiased TrueType font rendering using CLX and XRender extension. SHA256
    0ndy067rg9w6636gxwlpnw7f3ck9nrnjb03444pprik9r3c9in67 URL http://beta.quicklisp.org/archive/clx-truetype/2016-08-25/clx-truetype-20160825-git.tgz MD5
    7c9dedb21d52dedf727de741ac6d9c60 NAME clx-truetype TESTNAME NIL FILENAME clx-truetype DEPS
    ((NAME cl-aa) (NAME cl-fad) (NAME cl-paths-ttf) (NAME cl-store) (NAME cl-vectors) (NAME clx) (NAME trivial-features) (NAME zpb-ttf)) DEPENDENCIES
    (cl-aa cl-fad cl-paths-ttf cl-store cl-vectors clx trivial-features zpb-ttf) VERSION 20160825-git SIBLINGS NIL) */
