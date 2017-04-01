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

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-libuv[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-libuv DESCRIPTION Low-level libuv bindings for Common Lisp. SHA256 02vi9ph9pxbxgp9jsbgzb9nijsv0vyk3f1jyhhm88i0y1kb3595r URL
    http://beta.quicklisp.org/archive/cl-libuv/2016-08-25/cl-libuv-20160825-git.tgz MD5 ba5e3cfaadcf710eaee67cc9e716e45a NAME cl-libuv TESTNAME NIL FILENAME
    cl-libuv DEPS ((NAME alexandria) (NAME cffi) (NAME cffi-grovel)) DEPENDENCIES (alexandria cffi cffi-grovel) VERSION 20160825-git SIBLINGS NIL) */
