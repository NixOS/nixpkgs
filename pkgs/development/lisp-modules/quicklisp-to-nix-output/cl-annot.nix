args @ { fetchurl, ... }:
rec {
  baseName = ''cl-annot'';
  version = ''20150608-git'';

  description = ''Python-like Annotation Syntax for Common Lisp'';

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-annot/2015-06-08/cl-annot-20150608-git.tgz'';
    sha256 = ''0ixsp20rk498phv3iivipn3qbw7a7x260x63hc6kpv2s746lpdg3'';
  };
    
  packageName = "cl-annot";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-annot[.]asd${"$"}' |
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
/* (SYSTEM cl-annot DESCRIPTION Python-like Annotation Syntax for Common Lisp SHA256 0ixsp20rk498phv3iivipn3qbw7a7x260x63hc6kpv2s746lpdg3 URL
    http://beta.quicklisp.org/archive/cl-annot/2015-06-08/cl-annot-20150608-git.tgz MD5 35d8f79311bda4dd86002d11edcd0a21 NAME cl-annot TESTNAME NIL FILENAME
    cl-annot DEPS ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION 20150608-git SIBLINGS NIL) */
