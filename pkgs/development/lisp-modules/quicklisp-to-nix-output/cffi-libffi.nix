args @ { fetchurl, ... }:
rec {
  baseName = ''cffi-libffi'';
  version = ''cffi_0.18.0'';

  description = ''Foreign structures by value'';

  deps = [ args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2016-10-31/cffi_0.18.0.tgz'';
    sha256 = ''0g4clx9l9c7iw9hiv94ihzp4zb80yq3i5j6lr3vkz9z2dndzcpzz'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cffi-libffi[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cffi-libffi DESCRIPTION Foreign structures by value SHA256 0g4clx9l9c7iw9hiv94ihzp4zb80yq3i5j6lr3vkz9z2dndzcpzz URL
    http://beta.quicklisp.org/archive/cffi/2016-10-31/cffi_0.18.0.tgz MD5 5be207fca26205c7550d7b6307871f4e NAME cffi-libffi TESTNAME NIL FILENAME cffi-libffi
    DEPS ((NAME trivial-features)) DEPENDENCIES (trivial-features) VERSION cffi_0.18.0 SIBLINGS
    (cffi-examples cffi-grovel cffi-tests cffi-toolchain cffi-uffi-compat cffi)) */
