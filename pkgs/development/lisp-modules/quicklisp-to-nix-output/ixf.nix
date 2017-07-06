args @ { fetchurl, ... }:
rec {
  baseName = ''ixf'';
  version = ''cl-20170516-git'';

  description = ''Tools to handle IBM PC version of IXF file format'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ixf/2017-05-16/cl-ixf-20170516-git.tgz'';
    sha256 = ''0x32zlayynfj6g676afl0zna63jcgf333n3izapa84y5zgqp3nwf'';
  };
    
  packageName = "ixf";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/ixf[.]asd${"$"}' |
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
/* (SYSTEM ixf DESCRIPTION Tools to handle IBM PC version of IXF file format SHA256 0x32zlayynfj6g676afl0zna63jcgf333n3izapa84y5zgqp3nwf URL
    http://beta.quicklisp.org/archive/cl-ixf/2017-05-16/cl-ixf-20170516-git.tgz MD5 1c4c5ff76bb6fa9c19fe47d064c512b9 NAME ixf TESTNAME NIL FILENAME ixf DEPS
    NIL DEPENDENCIES NIL VERSION cl-20170516-git SIBLINGS NIL) */
