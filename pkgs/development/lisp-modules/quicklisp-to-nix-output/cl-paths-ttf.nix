args @ { fetchurl, ... }:
rec {
  baseName = ''cl-paths-ttf'';
  version = ''cl-vectors-20150407-git'';

  description = ''cl-paths-ttf: vectorial paths manipulation'';

  deps = [ args."zpb-ttf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-vectors/2015-04-07/cl-vectors-20150407-git.tgz'';
    sha256 = ''1qd7ywc2ayiyd5nw7shnjgh0nc14h328h0cw921g5b2n8j6y959w'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-paths-ttf[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cl-paths-ttf DESCRIPTION cl-paths-ttf: vectorial paths manipulation SHA256 1qd7ywc2ayiyd5nw7shnjgh0nc14h328h0cw921g5b2n8j6y959w URL
    http://beta.quicklisp.org/archive/cl-vectors/2015-04-07/cl-vectors-20150407-git.tgz MD5 9e255503bf4559912ea1511c919c474a NAME cl-paths-ttf TESTNAME NIL
    FILENAME cl-paths-ttf DEPS ((NAME zpb-ttf)) DEPENDENCIES (zpb-ttf) VERSION cl-vectors-20150407-git SIBLINGS (cl-aa-misc cl-aa cl-paths cl-vectors)) */
