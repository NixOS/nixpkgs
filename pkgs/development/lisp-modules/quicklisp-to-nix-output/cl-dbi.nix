args @ { fetchurl, ... }:
rec {
  baseName = ''cl-dbi'';
  version = ''20170124-git'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2017-01-24/cl-dbi-20170124-git.tgz'';
    sha256 = ''0aqfcxbxmc9q3lagaarx0bqncbwjjv0wrskm6lkzy1fp94sik0qj'';
  };
    
  packageName = "cl-dbi";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cl-dbi[.]asd${"$"}' |
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
/* (SYSTEM cl-dbi DESCRIPTION NIL SHA256 0aqfcxbxmc9q3lagaarx0bqncbwjjv0wrskm6lkzy1fp94sik0qj URL
    http://beta.quicklisp.org/archive/cl-dbi/2017-01-24/cl-dbi-20170124-git.tgz MD5 c48d284eda4aac1ff9a10891884f52e5 NAME cl-dbi TESTNAME NIL FILENAME cl-dbi
    DEPS NIL DEPENDENCIES NIL VERSION 20170124-git SIBLINGS (dbd-mysql dbd-postgres dbd-sqlite3 dbi-test dbi)) */
