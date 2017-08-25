args @ { fetchurl, ... }:
rec {
  baseName = ''iolib_slash_sockets'';
  version = ''iolib-v0.8.3'';

  description = ''Socket library.'';

  deps = [ args."swap-bytes" args."iolib_slash_syscalls" args."iolib_slash_streams" args."idna" args."cffi" args."bordeaux-threads" args."babel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2017-06-30/iolib-v0.8.3.tgz'';
    sha256 = ''12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c'';
  };
    
  packageName = "iolib/sockets";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/iolib/sockets[.]asd${"$"}' |
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
/* (SYSTEM iolib/sockets DESCRIPTION Socket library. SHA256 12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c URL
    http://beta.quicklisp.org/archive/iolib/2017-06-30/iolib-v0.8.3.tgz MD5 fc28d4cad6f8e43972df3baa6a8ac45c NAME iolib/sockets TESTNAME NIL FILENAME
    iolib_slash_sockets DEPS
    ((NAME swap-bytes FILENAME swap-bytes) (NAME iolib/syscalls FILENAME iolib_slash_syscalls) (NAME iolib/streams FILENAME iolib_slash_streams)
     (NAME idna FILENAME idna) (NAME cffi FILENAME cffi) (NAME bordeaux-threads FILENAME bordeaux-threads) (NAME babel FILENAME babel))
    DEPENDENCIES (swap-bytes iolib/syscalls iolib/streams idna cffi bordeaux-threads babel) VERSION iolib-v0.8.3 SIBLINGS
    (iolib iolib.asdf iolib.base iolib.common-lisp iolib.conf iolib.examples iolib.grovel iolib.tests)) */
