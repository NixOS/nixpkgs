args @ { fetchurl, ... }:
rec {
  baseName = ''cl-test-more'';
  version = ''prove-20170124-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/prove/2017-01-24/prove-20170124-git.tgz'';
    sha256 = ''1kyhh4yvf47psb5v0zqivcwn71n6my5fwggdifymlpigk2q3zn03'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-test-more[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-test-more DESCRIPTION NIL SHA256 1kyhh4yvf47psb5v0zqivcwn71n6my5fwggdifymlpigk2q3zn03 URL
    http://beta.quicklisp.org/archive/prove/2017-01-24/prove-20170124-git.tgz MD5 c5601ee1aebedc7272e2c25e6a5ca8be NAME cl-test-more TESTNAME NIL FILENAME
    cl-test-more DEPS NIL DEPENDENCIES NIL VERSION prove-20170124-git SIBLINGS (prove-asdf prove-test prove)) */
