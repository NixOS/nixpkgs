args @ { fetchurl, ... }:
rec {
  baseName = ''iolib'';
  version = ''v0.8.1'';

  description = ''I/O library.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."idna" args."split-sequence" args."swap-bytes" args."trivial-features" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2016-03-18/iolib-v0.8.1.tgz'';
    sha256 = ''090xmjzyx5d7arpk9g0fsyblwh6myq2d1cb7w52r3zy1394c9481'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/iolib[.]asd${"$"}' |
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
/* (SYSTEM iolib DESCRIPTION I/O library. SHA256 090xmjzyx5d7arpk9g0fsyblwh6myq2d1cb7w52r3zy1394c9481 URL
    http://beta.quicklisp.org/archive/iolib/2016-03-18/iolib-v0.8.1.tgz MD5 cd34c4f7db4af7391757ebc3f4f61422 NAME iolib TESTNAME NIL FILENAME iolib DEPS
    ((NAME alexandria) (NAME babel) (NAME bordeaux-threads) (NAME cffi) (NAME idna) (NAME split-sequence) (NAME swap-bytes) (NAME trivial-features)
     (NAME uiop))
    DEPENDENCIES (alexandria babel bordeaux-threads cffi idna split-sequence swap-bytes trivial-features uiop) VERSION v0.8.1 SIBLINGS NIL) */
