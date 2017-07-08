args @ { fetchurl, ... }:
rec {
  baseName = ''cl-anonfun'';
  version = ''20111203-git'';

  description = ''Anonymous function helpers for Common Lisp'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-anonfun/2011-12-03/cl-anonfun-20111203-git.tgz'';
    sha256 = ''16r3v3yba41smkqpz0qvzabkxashl39klfb6vxhzbly696x87p1m'';
  };
    
  packageName = "cl-anonfun";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-anonfun[.]asd${"$"}' |
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
/* (SYSTEM cl-anonfun DESCRIPTION Anonymous function helpers for Common Lisp SHA256 16r3v3yba41smkqpz0qvzabkxashl39klfb6vxhzbly696x87p1m URL
    http://beta.quicklisp.org/archive/cl-anonfun/2011-12-03/cl-anonfun-20111203-git.tgz MD5 915bda1a7653d42090f8d20a1ad85d0b NAME cl-anonfun TESTNAME NIL
    FILENAME cl-anonfun DEPS NIL DEPENDENCIES NIL VERSION 20111203-git SIBLINGS NIL) */
