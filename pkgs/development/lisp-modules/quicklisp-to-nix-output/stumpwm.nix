args @ { fetchurl, ... }:
rec {
  baseName = ''stumpwm'';
  version = ''20170227-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2017-02-27/stumpwm-20170227-git.tgz'';
    sha256 = ''0w1arw1x5hsw0w6rc1ls4bf7gf8cjcm6ar68kp74zczp0y35fign'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/stumpwm[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256 0w1arw1x5hsw0w6rc1ls4bf7gf8cjcm6ar68kp74zczp0y35fign URL
    http://beta.quicklisp.org/archive/stumpwm/2017-02-27/stumpwm-20170227-git.tgz MD5 076f2ec967024fcabc13eb921e6ce7c2 NAME stumpwm TESTNAME NIL FILENAME
    stumpwm DEPS NIL DEPENDENCIES NIL VERSION 20170227-git SIBLINGS NIL) */
