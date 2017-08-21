args @ { fetchurl, ... }:
rec {
  baseName = ''dbd-postgres'';
  version = ''cl-dbi-20170725-git'';

  description = ''Database driver for PostgreSQL.'';

  deps = [ args."trivial-garbage" args."cl-syntax-annot" args."cl-syntax" args."cl-postgres" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2017-07-25/cl-dbi-20170725-git.tgz'';
    sha256 = ''1gmd5y44nidqmxw7zk0mxl4mgl3mcjf1v05gjdslp3ginzznrqzl'';
  };
    
  packageName = "dbd-postgres";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/dbd-postgres[.]asd${"$"}' |
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
/* (SYSTEM dbd-postgres DESCRIPTION Database driver for PostgreSQL. SHA256 1gmd5y44nidqmxw7zk0mxl4mgl3mcjf1v05gjdslp3ginzznrqzl URL
    http://beta.quicklisp.org/archive/cl-dbi/2017-07-25/cl-dbi-20170725-git.tgz MD5 a9fe67b7fea2640cea9708342a1347bd NAME dbd-postgres TESTNAME NIL FILENAME
    dbd-postgres DEPS
    ((NAME trivial-garbage FILENAME trivial-garbage) (NAME cl-syntax-annot FILENAME cl-syntax-annot) (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-postgres FILENAME cl-postgres))
    DEPENDENCIES (trivial-garbage cl-syntax-annot cl-syntax cl-postgres) VERSION cl-dbi-20170725-git SIBLINGS (cl-dbi dbd-mysql dbd-sqlite3 dbi-test dbi)) */
