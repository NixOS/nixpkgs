args @ { fetchurl, ... }:
rec {
  baseName = ''prove'';
  version = ''20170124-git'';

  description = '''';

  deps = [ args."uiop" args."cl-ppcre" args."cl-colors" args."cl-ansi-text" args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/prove/2017-01-24/prove-20170124-git.tgz'';
    sha256 = ''1kyhh4yvf47psb5v0zqivcwn71n6my5fwggdifymlpigk2q3zn03'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/prove[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM prove DESCRIPTION NIL SHA256 1kyhh4yvf47psb5v0zqivcwn71n6my5fwggdifymlpigk2q3zn03 URL
    http://beta.quicklisp.org/archive/prove/2017-01-24/prove-20170124-git.tgz MD5 c5601ee1aebedc7272e2c25e6a5ca8be NAME prove TESTNAME NIL FILENAME prove DEPS
    ((NAME uiop) (NAME cl-ppcre) (NAME cl-colors) (NAME cl-ansi-text) (NAME alexandria)) DEPENDENCIES (uiop cl-ppcre cl-colors cl-ansi-text alexandria) VERSION
    20170124-git SIBLINGS (cl-test-more prove-asdf prove-test)) */
