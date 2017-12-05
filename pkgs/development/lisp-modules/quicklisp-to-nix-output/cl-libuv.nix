args @ { fetchurl, ... }:
rec {
  baseName = ''cl-libuv'';
  version = ''20160825-git'';

  description = ''Low-level libuv bindings for Common Lisp.'';

  deps = [ args."alexandria" args."cffi" args."cffi-grovel" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-libuv/2016-08-25/cl-libuv-20160825-git.tgz'';
    sha256 = ''02vi9ph9pxbxgp9jsbgzb9nijsv0vyk3f1jyhhm88i0y1kb3595r'';
  };
    
  packageName = "cl-libuv";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-libuv[.]asd${"$"}' |
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
/* (SYSTEM cl-libuv DESCRIPTION Low-level libuv bindings for Common Lisp. SHA256 02vi9ph9pxbxgp9jsbgzb9nijsv0vyk3f1jyhhm88i0y1kb3595r URL
    http://beta.quicklisp.org/archive/cl-libuv/2016-08-25/cl-libuv-20160825-git.tgz MD5 ba5e3cfaadcf710eaee67cc9e716e45a NAME cl-libuv TESTNAME NIL FILENAME
    cl-libuv DEPS ((NAME alexandria FILENAME alexandria) (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)) DEPENDENCIES
    (alexandria cffi cffi-grovel) VERSION 20160825-git SIBLINGS NIL) */
