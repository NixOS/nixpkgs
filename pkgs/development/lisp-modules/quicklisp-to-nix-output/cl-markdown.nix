args @ { fetchurl, ... }:
rec {
  baseName = ''cl-markdown'';
  version = ''20101006-darcs'';

  description = '''';

  deps = [ args."metatilities-base" args."metabang-bind" args."dynamic-classes" args."cl-ppcre" args."cl-containers" args."anaphora" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-markdown/2010-10-06/cl-markdown-20101006-darcs.tgz'';
    sha256 = ''1hrv7szhmhxgbadwrmf6wx4kwkbg3dnabbsz4hfffzjgprwac79w'';
  };
    
  packageName = "cl-markdown";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-markdown[.]asd${"$"}' |
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
/* (SYSTEM cl-markdown DESCRIPTION NIL SHA256 1hrv7szhmhxgbadwrmf6wx4kwkbg3dnabbsz4hfffzjgprwac79w URL
    http://beta.quicklisp.org/archive/cl-markdown/2010-10-06/cl-markdown-20101006-darcs.tgz MD5 3e748529531ad1dcbee5443fe24b6300 NAME cl-markdown TESTNAME NIL
    FILENAME cl-markdown DEPS
    ((NAME metatilities-base FILENAME metatilities-base) (NAME metabang-bind FILENAME metabang-bind) (NAME dynamic-classes FILENAME dynamic-classes)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-containers FILENAME cl-containers) (NAME anaphora FILENAME anaphora))
    DEPENDENCIES (metatilities-base metabang-bind dynamic-classes cl-ppcre cl-containers anaphora) VERSION 20101006-darcs SIBLINGS
    (cl-markdown-comparisons cl-markdown-test)) */
