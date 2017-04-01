args @ { fetchurl, ... }:
rec {
  baseName = ''cl-vectors'';
  version = ''20150407-git'';

  description = ''cl-paths: vectorial paths manipulation'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-vectors/2015-04-07/cl-vectors-20150407-git.tgz'';
    sha256 = ''1qd7ywc2ayiyd5nw7shnjgh0nc14h328h0cw921g5b2n8j6y959w'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-vectors[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-vectors DESCRIPTION cl-paths: vectorial paths manipulation SHA256 1qd7ywc2ayiyd5nw7shnjgh0nc14h328h0cw921g5b2n8j6y959w URL
    http://beta.quicklisp.org/archive/cl-vectors/2015-04-07/cl-vectors-20150407-git.tgz MD5 9e255503bf4559912ea1511c919c474a NAME cl-vectors TESTNAME NIL
    FILENAME cl-vectors DEPS NIL DEPENDENCIES NIL VERSION 20150407-git SIBLINGS (cl-aa-misc cl-aa cl-paths-ttf cl-paths)) */
