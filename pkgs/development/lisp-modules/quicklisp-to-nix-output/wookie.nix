args @ { fetchurl, ... }:
rec {
  baseName = ''wookie'';
  version = ''20170227-git'';

  description = ''An evented webserver for Common Lisp.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/wookie/2017-02-27/wookie-20170227-git.tgz'';
    sha256 = ''0i1wrgr5grg387ldv1zfswws1g3xvrkxxvp1m58m9hj0c1vmm6v0'';
  };
    
  packageName = "wookie";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/wookie[.]asd${"$"}' |
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
/* (SYSTEM wookie DESCRIPTION An evented webserver for Common Lisp. SHA256 0i1wrgr5grg387ldv1zfswws1g3xvrkxxvp1m58m9hj0c1vmm6v0 URL
    http://beta.quicklisp.org/archive/wookie/2017-02-27/wookie-20170227-git.tgz MD5 aeb084106facdc9c8dab100c97e05b92 NAME wookie TESTNAME NIL FILENAME wookie
    DEPS NIL DEPENDENCIES NIL VERSION 20170227-git SIBLINGS NIL) */
