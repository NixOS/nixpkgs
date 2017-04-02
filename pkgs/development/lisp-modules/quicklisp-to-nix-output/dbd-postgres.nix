args @ { fetchurl, ... }:
rec {
  baseName = ''dbd-postgres'';
  version = ''cl-dbi-20170124-git'';

  description = ''Database driver for PostgreSQL.'';

  deps = [ args."trivial-garbage" args."cl-syntax-annot" args."cl-syntax" args."cl-postgres" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2017-01-24/cl-dbi-20170124-git.tgz'';
    sha256 = ''0aqfcxbxmc9q3lagaarx0bqncbwjjv0wrskm6lkzy1fp94sik0qj'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/dbd-postgres[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM dbd-postgres DESCRIPTION Database driver for PostgreSQL. SHA256 0aqfcxbxmc9q3lagaarx0bqncbwjjv0wrskm6lkzy1fp94sik0qj URL
    http://beta.quicklisp.org/archive/cl-dbi/2017-01-24/cl-dbi-20170124-git.tgz MD5 c48d284eda4aac1ff9a10891884f52e5 NAME dbd-postgres TESTNAME NIL FILENAME
    dbd-postgres DEPS ((NAME trivial-garbage) (NAME cl-syntax-annot) (NAME cl-syntax) (NAME cl-postgres)) DEPENDENCIES
    (trivial-garbage cl-syntax-annot cl-syntax cl-postgres) VERSION cl-dbi-20170124-git SIBLINGS (cl-dbi dbd-mysql dbd-sqlite3 dbi-test dbi)) */
