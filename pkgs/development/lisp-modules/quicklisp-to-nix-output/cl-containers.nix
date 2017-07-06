args @ { fetchurl, ... }:
rec {
  baseName = ''cl-containers'';
  version = ''20170403-git'';

  description = ''A generic container library for Common Lisp'';

  deps = [ args."metatilities-base" args."asdf-system-connections" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-containers/2017-04-03/cl-containers-20170403-git.tgz'';
    sha256 = ''0wlwbz5xv3468iszvmfxnj924mdwx0lyzmhsggiq7iq7ip8wbbxg'';
  };
    
  packageName = "cl-containers";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-containers[.]asd${"$"}' |
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
/* (SYSTEM cl-containers DESCRIPTION A generic container library for Common Lisp SHA256 0wlwbz5xv3468iszvmfxnj924mdwx0lyzmhsggiq7iq7ip8wbbxg URL
    http://beta.quicklisp.org/archive/cl-containers/2017-04-03/cl-containers-20170403-git.tgz MD5 17123cd2b018cd3eb048eceef78be3f8 NAME cl-containers TESTNAME
    NIL FILENAME cl-containers DEPS ((NAME metatilities-base FILENAME metatilities-base) (NAME asdf-system-connections FILENAME asdf-system-connections))
    DEPENDENCIES (metatilities-base asdf-system-connections) VERSION 20170403-git SIBLINGS (cl-containers-test)) */
