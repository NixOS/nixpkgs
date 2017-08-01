args @ { fetchurl, ... }:
rec {
  baseName = ''dbd-sqlite3'';
  version = ''cl-dbi-20170725-git'';

  description = ''Database driver for SQLite3.'';

  deps = [ args."uiop" args."sqlite" args."cl-syntax-annot" args."cl-syntax" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2017-07-25/cl-dbi-20170725-git.tgz'';
    sha256 = ''1gmd5y44nidqmxw7zk0mxl4mgl3mcjf1v05gjdslp3ginzznrqzl'';
  };
    
  packageName = "dbd-sqlite3";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/dbd-sqlite3[.]asd${"$"}' |
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
/* (SYSTEM dbd-sqlite3 DESCRIPTION Database driver for SQLite3. SHA256 1gmd5y44nidqmxw7zk0mxl4mgl3mcjf1v05gjdslp3ginzznrqzl URL
    http://beta.quicklisp.org/archive/cl-dbi/2017-07-25/cl-dbi-20170725-git.tgz MD5 a9fe67b7fea2640cea9708342a1347bd NAME dbd-sqlite3 TESTNAME NIL FILENAME
    dbd-sqlite3 DEPS
    ((NAME uiop FILENAME uiop) (NAME sqlite FILENAME sqlite) (NAME cl-syntax-annot FILENAME cl-syntax-annot) (NAME cl-syntax FILENAME cl-syntax)) DEPENDENCIES
    (uiop sqlite cl-syntax-annot cl-syntax) VERSION cl-dbi-20170725-git SIBLINGS (cl-dbi dbd-mysql dbd-postgres dbi-test dbi)) */
