args @ { fetchurl, ... }:
rec {
  baseName = ''cffi-grovel'';
  version = ''cffi_0.19.0'';

  description = ''The CFFI Groveller'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2017-06-30/cffi_0.19.0.tgz'';
    sha256 = ''12v3ha0qp3f9lq2h3d7y3mwdq216nsdfig0s3c4akw90rsbnydj9'';
  };
    
  packageName = "cffi-grovel";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cffi-grovel[.]asd${"$"}' |
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
/* (SYSTEM cffi-grovel DESCRIPTION The CFFI Groveller SHA256 12v3ha0qp3f9lq2h3d7y3mwdq216nsdfig0s3c4akw90rsbnydj9 URL
    http://beta.quicklisp.org/archive/cffi/2017-06-30/cffi_0.19.0.tgz MD5 7589b6437fec19fdabc65892536c3dc3 NAME cffi-grovel TESTNAME NIL FILENAME cffi-grovel
    DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION cffi_0.19.0 SIBLINGS
    (cffi-examples cffi-libffi cffi-tests cffi-toolchain cffi-uffi-compat cffi)) */
