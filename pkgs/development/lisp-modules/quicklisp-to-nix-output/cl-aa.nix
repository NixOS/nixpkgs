args @ { fetchurl, ... }:
rec {
  baseName = ''cl-aa'';
  version = ''cl-vectors-20170630-git'';

  description = ''cl-aa: polygon rasterizer'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-vectors/2017-06-30/cl-vectors-20170630-git.tgz'';
    sha256 = ''0820qwi6pp8683rqp37x9l9shm0vh873bc4p9q38cz56ck7il740'';
  };
    
  packageName = "cl-aa";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-aa[.]asd${"$"}' |
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
/* (SYSTEM cl-aa DESCRIPTION cl-aa: polygon rasterizer SHA256 0820qwi6pp8683rqp37x9l9shm0vh873bc4p9q38cz56ck7il740 URL
    http://beta.quicklisp.org/archive/cl-vectors/2017-06-30/cl-vectors-20170630-git.tgz MD5 cee3bb14adbba3142b782c646f7651ce NAME cl-aa TESTNAME NIL FILENAME
    cl-aa DEPS NIL DEPENDENCIES NIL VERSION cl-vectors-20170630-git SIBLINGS (cl-aa-misc cl-paths-ttf cl-paths cl-vectors)) */
