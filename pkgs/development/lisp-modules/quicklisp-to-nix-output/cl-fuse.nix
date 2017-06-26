args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fuse'';
  version = ''20160318-git'';

  description = ''CFFI bindings to FUSE (Filesystem in user space)'';

  deps = [ args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cl-utilities" args."iterate" args."trivial-backtrace" args."trivial-utf-8" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fuse/2016-03-18/cl-fuse-20160318-git.tgz'';
    sha256 = ''1yllmnnhqp42s37a2y7h7vph854xgna62l1pidvlyskc90bl5jf6'';
  };
    
  packageName = "cl-fuse";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-fuse[.]asd${"$"}' |
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
/* (SYSTEM cl-fuse DESCRIPTION CFFI bindings to FUSE (Filesystem in user space) SHA256 1yllmnnhqp42s37a2y7h7vph854xgna62l1pidvlyskc90bl5jf6 URL
    http://beta.quicklisp.org/archive/cl-fuse/2016-03-18/cl-fuse-20160318-git.tgz MD5 ce2e907e5ae2cece72fa314be1ced44c NAME cl-fuse TESTNAME NIL FILENAME
    cl-fuse DEPS
    ((NAME bordeaux-threads FILENAME bordeaux-threads) (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cl-utilities FILENAME cl-utilities) (NAME iterate FILENAME iterate) (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-utf-8 FILENAME trivial-utf-8))
    DEPENDENCIES (bordeaux-threads cffi cffi-grovel cl-utilities iterate trivial-backtrace trivial-utf-8) VERSION 20160318-git SIBLINGS NIL) */
