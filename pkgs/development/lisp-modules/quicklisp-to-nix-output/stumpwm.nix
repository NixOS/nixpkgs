args @ { fetchurl, ... }:
rec {
  baseName = ''stumpwm'';
  version = ''20170725-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ args."alexandria" args."cl-ppcre" args."clx" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2017-07-25/stumpwm-20170725-git.tgz'';
    sha256 = ''1hb01zlm4rk2n9b8lfpiary94pmg6qkw84zg54ws1if7z1yd2ss5'';
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
/* (SYSTEM stumpwm DESCRIPTION A tiling, keyboard driven window manager SHA256 1hb01zlm4rk2n9b8lfpiary94pmg6qkw84zg54ws1if7z1yd2ss5 URL
    http://beta.quicklisp.org/archive/stumpwm/2017-07-25/stumpwm-20170725-git.tgz MD5 a7fb260c6572273c05b828299c0610ce NAME stumpwm TESTNAME NIL FILENAME
    stumpwm DEPS ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre) (NAME clx FILENAME clx)) DEPENDENCIES (alexandria cl-ppcre clx)
    VERSION 20170725-git SIBLINGS NIL) */
