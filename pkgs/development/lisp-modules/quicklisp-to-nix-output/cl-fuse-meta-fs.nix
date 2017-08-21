args @ { fetchurl, ... }:
rec {
  baseName = ''cl-fuse-meta-fs'';
  version = ''20150608-git'';

  description = ''CFFI bindings to FUSE (Filesystem in user space)'';

  deps = [ args."bordeaux-threads" args."cl-fuse" args."iterate" args."pcall" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-fuse-meta-fs/2015-06-08/cl-fuse-meta-fs-20150608-git.tgz'';
    sha256 = ''1i3yw237ygwlkhbcbm9q54ad9g4fi63fw4mg508hr7bz9gzg36q2'';
  };
    
  packageName = "cl-fuse-meta-fs";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-fuse-meta-fs[.]asd${"$"}' |
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
/* (SYSTEM cl-fuse-meta-fs DESCRIPTION CFFI bindings to FUSE (Filesystem in user space) SHA256 1i3yw237ygwlkhbcbm9q54ad9g4fi63fw4mg508hr7bz9gzg36q2 URL
    http://beta.quicklisp.org/archive/cl-fuse-meta-fs/2015-06-08/cl-fuse-meta-fs-20150608-git.tgz MD5 eb80b959dd6494cd787cff4f8c2f214b NAME cl-fuse-meta-fs
    TESTNAME NIL FILENAME cl-fuse-meta-fs DEPS
    ((NAME bordeaux-threads FILENAME bordeaux-threads) (NAME cl-fuse FILENAME cl-fuse) (NAME iterate FILENAME iterate) (NAME pcall FILENAME pcall))
    DEPENDENCIES (bordeaux-threads cl-fuse iterate pcall) VERSION 20150608-git SIBLINGS NIL) */
