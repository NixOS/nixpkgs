args @ { fetchurl, ... }:
rec {
  baseName = ''cl-colors'';
  version = ''20151218-git'';

  description = ''Simple color library for Common Lisp'';

  deps = [ args."alexandria" args."let-plus" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-colors/2015-12-18/cl-colors-20151218-git.tgz'';
    sha256 = ''032kswn6h2ib7v8v1dg0lmgfks7zk52wrv31q6p2zj2a156ccqp4'';
  };
    
  packageName = "cl-colors";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-colors[.]asd${"$"}' |
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
/* (SYSTEM cl-colors DESCRIPTION Simple color library for Common Lisp SHA256 032kswn6h2ib7v8v1dg0lmgfks7zk52wrv31q6p2zj2a156ccqp4 URL
    http://beta.quicklisp.org/archive/cl-colors/2015-12-18/cl-colors-20151218-git.tgz MD5 2963c3e7aca2c5db2132394f83716515 NAME cl-colors TESTNAME NIL FILENAME
    cl-colors DEPS ((NAME alexandria FILENAME alexandria) (NAME let-plus FILENAME let-plus)) DEPENDENCIES (alexandria let-plus) VERSION 20151218-git SIBLINGS
    NIL) */
