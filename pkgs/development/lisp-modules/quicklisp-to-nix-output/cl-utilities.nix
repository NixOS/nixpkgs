args @ { fetchurl, ... }:
rec {
  baseName = ''cl-utilities'';
  version = ''1.2.4'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-utilities/2010-10-06/cl-utilities-1.2.4.tgz'';
    sha256 = ''1z2ippnv2wgyxpz15zpif7j7sp1r20fkjhm4n6am2fyp6a3k3a87'';
  };
    
  packageName = "cl-utilities";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-utilities[.]asd${"$"}' |
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
/* (SYSTEM cl-utilities DESCRIPTION NIL SHA256 1z2ippnv2wgyxpz15zpif7j7sp1r20fkjhm4n6am2fyp6a3k3a87 URL
    http://beta.quicklisp.org/archive/cl-utilities/2010-10-06/cl-utilities-1.2.4.tgz MD5 c3a4ba38b627448d3ed40ce888048940 NAME cl-utilities TESTNAME NIL
    FILENAME cl-utilities DEPS NIL DEPENDENCIES NIL VERSION 1.2.4 SIBLINGS NIL) */
