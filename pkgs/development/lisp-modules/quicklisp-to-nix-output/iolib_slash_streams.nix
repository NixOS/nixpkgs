args @ { fetchurl, ... }:
rec {
  baseName = ''iolib_slash_streams'';
  version = ''iolib-v0.8.3'';

  description = ''Gray streams.'';

  deps = [ args."iolib_slash_multiplex" args."cffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2017-06-30/iolib-v0.8.3.tgz'';
    sha256 = ''12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c'';
  };
    
  packageName = "iolib/streams";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/iolib/streams[.]asd${"$"}' |
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
/* (SYSTEM iolib/streams DESCRIPTION Gray streams. SHA256 12gsvsjyxmclwidcjvyrfvd0773ib54a3qzmf33hmgc9knxlli7c URL
    http://beta.quicklisp.org/archive/iolib/2017-06-30/iolib-v0.8.3.tgz MD5 fc28d4cad6f8e43972df3baa6a8ac45c NAME iolib/streams TESTNAME NIL FILENAME
    iolib_slash_streams DEPS ((NAME iolib/multiplex FILENAME iolib_slash_multiplex) (NAME cffi FILENAME cffi)) DEPENDENCIES (iolib/multiplex cffi) VERSION
    iolib-v0.8.3 SIBLINGS (iolib iolib.asdf iolib.base iolib.common-lisp iolib.conf iolib.examples iolib.grovel iolib.tests)) */
