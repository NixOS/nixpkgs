args @ { fetchurl, ... }:
rec {
  baseName = ''cffi-grovel'';
  version = ''cffi_0.18.0'';

  description = ''The CFFI Groveller'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2016-10-31/cffi_0.18.0.tgz'';
    sha256 = ''0g4clx9l9c7iw9hiv94ihzp4zb80yq3i5j6lr3vkz9z2dndzcpzz'';
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
/* (SYSTEM cffi-grovel DESCRIPTION The CFFI Groveller SHA256 0g4clx9l9c7iw9hiv94ihzp4zb80yq3i5j6lr3vkz9z2dndzcpzz URL
    http://beta.quicklisp.org/archive/cffi/2016-10-31/cffi_0.18.0.tgz MD5 5be207fca26205c7550d7b6307871f4e NAME cffi-grovel TESTNAME NIL FILENAME cffi-grovel
    DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION cffi_0.18.0 SIBLINGS
    (cffi-examples cffi-libffi cffi-tests cffi-toolchain cffi-uffi-compat cffi)) */
