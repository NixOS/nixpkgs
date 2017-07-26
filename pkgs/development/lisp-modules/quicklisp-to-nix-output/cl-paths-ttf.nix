args @ { fetchurl, ... }:
rec {
  baseName = ''cl-paths-ttf'';
  version = ''cl-vectors-20170516-git'';

  description = ''cl-paths-ttf: vectorial paths manipulation'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-vectors/2017-05-16/cl-vectors-20170516-git.tgz'';
    sha256 = ''0j7cdg6akq5giv8rgbxdv8rwpzkv98r5bv78p5nnrixpprvjhvzx'';
  };
    
  packageName = "cl-paths-ttf";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-paths-ttf[.]asd${"$"}' |
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
/* (SYSTEM cl-paths-ttf DESCRIPTION cl-paths-ttf: vectorial paths manipulation SHA256 0j7cdg6akq5giv8rgbxdv8rwpzkv98r5bv78p5nnrixpprvjhvzx URL
    http://beta.quicklisp.org/archive/cl-vectors/2017-05-16/cl-vectors-20170516-git.tgz MD5 0258ae7face22f2035c1a85379ee0aae NAME cl-paths-ttf TESTNAME NIL
    FILENAME cl-paths-ttf DEPS NIL DEPENDENCIES NIL VERSION cl-vectors-20170516-git SIBLINGS (cl-aa-misc cl-aa cl-paths cl-vectors)) */
