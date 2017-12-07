args @ { fetchurl, ... }:
rec {
  baseName = ''iolib'';
  version = ''v0.8.3'';

  description = ''I/O library.'';

  deps = [ args."iolib_slash_streams" args."iolib_slash_sockets" args."iolib_slash_multiplex" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2017-06-30/iolib-v0.8.3.tgz'';
    sha256 = ''12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c'';
  };
    
  packageName = "iolib";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/iolib[.]asd${"$"}' |
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
/* (SYSTEM iolib DESCRIPTION I/O library. SHA256 12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c URL
    http://beta.quicklisp.org/archive/iolib/2017-06-30/iolib-v0.8.3.tgz MD5 fc28d4cad6f8e43972df3baa6a8ac45c NAME iolib TESTNAME NIL FILENAME iolib DEPS
    ((NAME iolib/streams FILENAME iolib_slash_streams) (NAME iolib/sockets FILENAME iolib_slash_sockets) (NAME iolib/multiplex FILENAME iolib_slash_multiplex))
    DEPENDENCIES (iolib/streams iolib/sockets iolib/multiplex) VERSION v0.8.3 SIBLINGS
    (iolib.asdf iolib.base iolib.common-lisp iolib.conf iolib.examples iolib.grovel iolib.tests)) */
