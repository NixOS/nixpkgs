args @ { fetchurl, ... }:
rec {
  baseName = ''clsql'';
  version = ''20160208-git'';

  description = ''Common Lisp SQL Interface library'';

  deps = [ args."uffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz'';
    sha256 = ''0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn'';
  };
    
  packageName = "clsql";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/clsql[.]asd${"$"}' |
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
/* (SYSTEM clsql DESCRIPTION Common Lisp SQL Interface library SHA256 0hc97rlfpanp6c1ziis47mrq2fgxbk0h51bhczn8k9xin2qbhhgn URL
    http://beta.quicklisp.org/archive/clsql/2016-02-08/clsql-20160208-git.tgz MD5 d1da7688361337a7de4fe7452c225a06 NAME clsql TESTNAME NIL FILENAME clsql DEPS
    ((NAME uffi FILENAME uffi)) DEPENDENCIES (uffi) VERSION 20160208-git SIBLINGS
    (clsql-aodbc clsql-cffi clsql-mysql clsql-odbc clsql-postgresql-socket clsql-postgresql-socket3 clsql-postgresql clsql-sqlite clsql-sqlite3 clsql-tests
     clsql-uffi)) */
