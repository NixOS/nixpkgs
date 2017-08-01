args @ { fetchurl, ... }:
rec {
  baseName = ''mssql'';
  version = ''cl-20170630-git'';

  description = '''';

  deps = [ args."cffi" args."garbage-pools" args."iterate" args."parse-number" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-mssql/2017-06-30/cl-mssql-20170630-git.tgz'';
    sha256 = ''0vwssk39m8pqn8srwvbcnq43wkqlav5rvq64byrnpsrwlfcbfvxy'';
  };
    
  packageName = "mssql";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/mssql[.]asd${"$"}' |
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
/* (SYSTEM mssql DESCRIPTION NIL SHA256 0vwssk39m8pqn8srwvbcnq43wkqlav5rvq64byrnpsrwlfcbfvxy URL
    http://beta.quicklisp.org/archive/cl-mssql/2017-06-30/cl-mssql-20170630-git.tgz MD5 88e65c72923896df603ecf20039ae305 NAME mssql TESTNAME NIL FILENAME mssql
    DEPS ((NAME cffi FILENAME cffi) (NAME garbage-pools FILENAME garbage-pools) (NAME iterate FILENAME iterate) (NAME parse-number FILENAME parse-number))
    DEPENDENCIES (cffi garbage-pools iterate parse-number) VERSION cl-20170630-git SIBLINGS NIL) */
