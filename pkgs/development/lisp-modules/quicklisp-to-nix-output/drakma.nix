args @ { fetchurl, ... }:
rec {
  baseName = ''drakma'';
  version = ''2.0.2'';

  description = ''Full-featured http/https client based on usocket'';

  deps = [ args."usocket" args."puri" args."flexi-streams" args."cl-ppcre" args."cl-base64" args."cl+ssl" args."chunga" args."chipz" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/drakma/2015-10-31/drakma-2.0.2.tgz'';
    sha256 = ''1bpwh19fxd1ncvwai2ab2363bk6qkpwch5sa4csbiawcihyawh2z'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/drakma[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM drakma DESCRIPTION Full-featured http/https client based on usocket SHA256 1bpwh19fxd1ncvwai2ab2363bk6qkpwch5sa4csbiawcihyawh2z URL
    http://beta.quicklisp.org/archive/drakma/2015-10-31/drakma-2.0.2.tgz MD5 eb51e1417c02c912c2b43bd9605dfb50 NAME drakma TESTNAME NIL FILENAME drakma DEPS
    ((NAME usocket) (NAME puri) (NAME flexi-streams) (NAME cl-ppcre) (NAME cl-base64) (NAME cl+ssl) (NAME chunga) (NAME chipz)) DEPENDENCIES
    (usocket puri flexi-streams cl-ppcre cl-base64 cl+ssl chunga chipz) VERSION 2.0.2 SIBLINGS (drakma-test)) */
