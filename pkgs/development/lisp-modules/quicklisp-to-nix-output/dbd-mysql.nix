args @ { fetchurl, ... }:
rec {
  baseName = ''dbd-mysql'';
  version = ''cl-dbi-20170124-git'';

  description = ''Database driver for MySQL.'';

  deps = [ args."cl-syntax-annot" args."cl-syntax" args."cl-mysql" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-dbi/2017-01-24/cl-dbi-20170124-git.tgz'';
    sha256 = ''0aqfcxbxmc9q3lagaarx0bqncbwjjv0wrskm6lkzy1fp94sik0qj'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/dbd-mysql[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM dbd-mysql DESCRIPTION Database driver for MySQL. SHA256 0aqfcxbxmc9q3lagaarx0bqncbwjjv0wrskm6lkzy1fp94sik0qj URL
    http://beta.quicklisp.org/archive/cl-dbi/2017-01-24/cl-dbi-20170124-git.tgz MD5 c48d284eda4aac1ff9a10891884f52e5 NAME dbd-mysql TESTNAME NIL FILENAME
    dbd-mysql DEPS ((NAME cl-syntax-annot) (NAME cl-syntax) (NAME cl-mysql)) DEPENDENCIES (cl-syntax-annot cl-syntax cl-mysql) VERSION cl-dbi-20170124-git
    SIBLINGS (cl-dbi dbd-postgres dbd-sqlite3 dbi-test dbi)) */
