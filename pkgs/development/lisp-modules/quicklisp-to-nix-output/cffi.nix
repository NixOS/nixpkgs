args @ { fetchurl, ... }:
rec {
  baseName = ''cffi'';
  version = ''cffi_0.19.0'';

  description = ''The Common Foreign Function Interface'';

  deps = [ args."uiop" args."trivial-features" args."babel" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2017-06-30/cffi_0.19.0.tgz'';
    sha256 = ''12v3ha0qp3f9lq2h3d7y3mwdq216nsdfig0s3c4akw90rsbnydj9'';
  };
    
  packageName = "cffi";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cffi[.]asd${"$"}' |
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
/* (SYSTEM cffi DESCRIPTION The Common Foreign Function Interface SHA256 12v3ha0qp3f9lq2h3d7y3mwdq216nsdfig0s3c4akw90rsbnydj9 URL
    http://beta.quicklisp.org/archive/cffi/2017-06-30/cffi_0.19.0.tgz MD5 7589b6437fec19fdabc65892536c3dc3 NAME cffi TESTNAME NIL FILENAME cffi DEPS
    ((NAME uiop FILENAME uiop) (NAME trivial-features FILENAME trivial-features) (NAME babel FILENAME babel) (NAME alexandria FILENAME alexandria))
    DEPENDENCIES (uiop trivial-features babel alexandria) VERSION cffi_0.19.0 SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-toolchain cffi-uffi-compat)) */
