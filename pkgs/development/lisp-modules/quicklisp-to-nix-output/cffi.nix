args @ { fetchurl, ... }:
rec {
  baseName = ''cffi'';
  version = ''cffi_0.18.0'';

  description = ''The Common Foreign Function Interface'';

  deps = [ args."uiop" args."trivial-features" args."babel" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2016-10-31/cffi_0.18.0.tgz'';
    sha256 = ''0g4clx9l9c7iw9hiv94ihzp4zb80yq3i5j6lr3vkz9z2dndzcpzz'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cffi[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cffi DESCRIPTION The Common Foreign Function Interface SHA256 0g4clx9l9c7iw9hiv94ihzp4zb80yq3i5j6lr3vkz9z2dndzcpzz URL
    http://beta.quicklisp.org/archive/cffi/2016-10-31/cffi_0.18.0.tgz MD5 5be207fca26205c7550d7b6307871f4e NAME cffi TESTNAME NIL FILENAME cffi DEPS
    ((NAME uiop) (NAME trivial-features) (NAME babel) (NAME alexandria)) DEPENDENCIES (uiop trivial-features babel alexandria) VERSION cffi_0.18.0 SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-toolchain cffi-uffi-compat)) */
