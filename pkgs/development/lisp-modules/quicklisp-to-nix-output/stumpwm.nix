args @ { fetchurl, ... }:
rec {
  baseName = ''stumpwm'';
  version = ''20170516-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2017-05-16/stumpwm-20170516-git.tgz'';
    sha256 = ''0x3x0w1akarp0rjmig9x6d729z6lv6ywfg00b6xszm5kqfbx1659'';
  };
    
  packageName = "stumpwm";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/stumpwm[.]asd${"$"}' |
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
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256 0x3x0w1akarp0rjmig9x6d729z6lv6ywfg00b6xszm5kqfbx1659 URL
    http://beta.quicklisp.org/archive/stumpwm/2017-05-16/stumpwm-20170516-git.tgz MD5 ed076f733ef138aca3b04b3c3ff748f0 NAME stumpwm TESTNAME NIL FILENAME
    stumpwm DEPS NIL DEPENDENCIES NIL VERSION 20170516-git SIBLINGS NIL) */
