args @ { fetchurl, ... }:
rec {
  baseName = ''pgloader'';
  version = ''3.3.2'';

  description = ''Load data into PostgreSQL'';

  deps = [ args."abnf" args."alexandria" args."cl-base64" args."cl-csv" args."cl-fad" args."cl-log" args."cl-markdown" args."cl-postgres" args."cl-ppcre" args."command-line-arguments" args."db3" args."drakma" args."esrap" args."flexi-streams" args."ixf" args."local-time" args."lparallel" args."metabang-bind" args."mssql" args."postmodern" args."py-configparser" args."qmynd" args."quri" args."simple-date" args."split-sequence" args."sqlite" args."trivial-backtrace" args."uiop" args."usocket" args."uuid" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/pgloader/2016-12-04/pgloader-3.3.2.tgz'';
    sha256 = ''1riz76jvjlszic48lndwfxjn9i72251frivaqi10k61gjfbx03qv'';
  };
    
  packageName = "pgloader";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/pgloader[.]asd${"$"}' |
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
/* (SYSTEM pgloader DESCRIPTION Load data into PostgreSQL SHA256 1riz76jvjlszic48lndwfxjn9i72251frivaqi10k61gjfbx03qv URL
    http://beta.quicklisp.org/archive/pgloader/2016-12-04/pgloader-3.3.2.tgz MD5 fb72ca0db46b80a74b7b31dc5b27e1b8 NAME pgloader TESTNAME NIL FILENAME pgloader
    DEPS
    ((NAME abnf FILENAME abnf) (NAME alexandria FILENAME alexandria) (NAME cl-base64 FILENAME cl-base64) (NAME cl-csv FILENAME cl-csv)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-log FILENAME cl-log) (NAME cl-markdown FILENAME cl-markdown) (NAME cl-postgres FILENAME cl-postgres)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME command-line-arguments FILENAME command-line-arguments) (NAME db3 FILENAME db3) (NAME drakma FILENAME drakma)
     (NAME esrap FILENAME esrap) (NAME flexi-streams FILENAME flexi-streams) (NAME ixf FILENAME ixf) (NAME local-time FILENAME local-time)
     (NAME lparallel FILENAME lparallel) (NAME metabang-bind FILENAME metabang-bind) (NAME mssql FILENAME mssql) (NAME postmodern FILENAME postmodern)
     (NAME py-configparser FILENAME py-configparser) (NAME qmynd FILENAME qmynd) (NAME quri FILENAME quri) (NAME simple-date FILENAME simple-date)
     (NAME split-sequence FILENAME split-sequence) (NAME sqlite FILENAME sqlite) (NAME trivial-backtrace FILENAME trivial-backtrace) (NAME uiop FILENAME uiop)
     (NAME usocket FILENAME usocket) (NAME uuid FILENAME uuid))
    DEPENDENCIES
    (abnf alexandria cl-base64 cl-csv cl-fad cl-log cl-markdown cl-postgres cl-ppcre command-line-arguments db3 drakma esrap flexi-streams ixf local-time
     lparallel metabang-bind mssql postmodern py-configparser qmynd quri simple-date split-sequence sqlite trivial-backtrace uiop usocket uuid)
    VERSION 3.3.2 SIBLINGS NIL) */
