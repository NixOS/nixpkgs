args @ { fetchurl, ... }:
rec {
  baseName = ''cl-project'';
  version = ''20160531-git'';

  description = ''Generate a skeleton for modern project'';

  deps = [ args."uiop" args."prove" args."local-time" args."cl-ppcre" args."cl-emb" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-project/2016-05-31/cl-project-20160531-git.tgz'';
    sha256 = ''1xwjgs5pzkdnd9i5lcic9z41d1c4yf7pvarrvawfxcicg6rrfw81'';
  };
    
  packageName = "cl-project";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-project[.]asd${"$"}' |
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
/* (SYSTEM cl-project DESCRIPTION Generate a skeleton for modern project SHA256 1xwjgs5pzkdnd9i5lcic9z41d1c4yf7pvarrvawfxcicg6rrfw81 URL
    http://beta.quicklisp.org/archive/cl-project/2016-05-31/cl-project-20160531-git.tgz MD5 63de5ce6f0f3e5f60094a86d32c2f1a9 NAME cl-project TESTNAME NIL
    FILENAME cl-project DEPS
    ((NAME uiop FILENAME uiop) (NAME prove FILENAME prove) (NAME local-time FILENAME local-time) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-emb FILENAME cl-emb))
    DEPENDENCIES (uiop prove local-time cl-ppcre cl-emb) VERSION 20160531-git SIBLINGS (cl-project-test)) */
