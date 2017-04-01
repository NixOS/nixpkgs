args @ { fetchurl, ... }:
rec {
  baseName = ''query-fs'';
  version = ''20160531-git'';

  description = ''High-level virtual FS using CL-Fuse-Meta-FS to represent results of queries'';

  deps = [ args."bordeaux-threads" args."cl-fuse" args."cl-fuse-meta-fs" args."cl-ppcre" args."command-line-arguments" args."iterate" args."trivial-backtrace" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/query-fs/2016-05-31/query-fs-20160531-git.tgz'';
    sha256 = ''0wknr3rffihg1my8ihmpwssxpxj4bfmqcly0s37q51fllxkr1v5a'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/query-fs[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM query-fs DESCRIPTION High-level virtual FS using CL-Fuse-Meta-FS to represent results of queries SHA256
    0wknr3rffihg1my8ihmpwssxpxj4bfmqcly0s37q51fllxkr1v5a URL http://beta.quicklisp.org/archive/query-fs/2016-05-31/query-fs-20160531-git.tgz MD5
    dfbb3d0e7b5d990488a17b184771d049 NAME query-fs TESTNAME NIL FILENAME query-fs DEPS
    ((NAME bordeaux-threads) (NAME cl-fuse) (NAME cl-fuse-meta-fs) (NAME cl-ppcre) (NAME command-line-arguments) (NAME iterate) (NAME trivial-backtrace))
    DEPENDENCIES (bordeaux-threads cl-fuse cl-fuse-meta-fs cl-ppcre command-line-arguments iterate trivial-backtrace) VERSION 20160531-git SIBLINGS NIL) */
