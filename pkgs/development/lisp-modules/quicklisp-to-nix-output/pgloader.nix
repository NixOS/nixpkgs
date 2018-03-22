args @ { fetchurl, ... }:
rec {
  baseName = ''pgloader'';
  version = ''v3.4.1'';

  description = ''Load data into PostgreSQL'';

  deps = [ args."abnf" args."alexandria" args."anaphora" args."asdf-finalizers" args."asdf-system-connections" args."babel" args."bordeaux-threads" args."cffi" args."chipz" args."chunga" args."cl_plus_ssl" args."cl-base64" args."cl-containers" args."cl-csv" args."cl-fad" args."cl-interpol" args."cl-log" args."cl-markdown" args."cl-postgres" args."cl-ppcre" args."cl-unicode" args."cl-utilities" args."closer-mop" args."command-line-arguments" args."db3" args."drakma" args."dynamic-classes" args."esrap" args."flexi-streams" args."garbage-pools" args."ieee-floats" args."ironclad" args."iterate" args."ixf" args."list-of" args."local-time" args."lparallel" args."md5" args."metabang-bind" args."metatilities-base" args."mssql" args."nibbles" args."parse-number" args."postmodern" args."puri" args."py-configparser" args."qmynd" args."quri" args."s-sql" args."salza2" args."simple-date" args."split-sequence" args."sqlite" args."trivial-backtrace" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."trivial-utf-8" args."uiop" args."usocket" args."uuid" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/pgloader/2017-08-30/pgloader-v3.4.1.tgz'';
    sha256 = ''1z6p7dz1ir9cg4gl1vkvbc1f7pv1yfv1jgwjkw29v57fdg4faz9v'';
  };

  packageName = "pgloader";

  asdFilesToKeep = ["pgloader.asd"];
  overrides = x: x;
}
/* (SYSTEM pgloader DESCRIPTION Load data into PostgreSQL SHA256
    1z6p7dz1ir9cg4gl1vkvbc1f7pv1yfv1jgwjkw29v57fdg4faz9v URL
    http://beta.quicklisp.org/archive/pgloader/2017-08-30/pgloader-v3.4.1.tgz
    MD5 6741f8e7d2d416942d5c4a1971576d33 NAME pgloader FILENAME pgloader DEPS
    ((NAME abnf FILENAME abnf) (NAME alexandria FILENAME alexandria)
     (NAME anaphora FILENAME anaphora)
     (NAME asdf-finalizers FILENAME asdf-finalizers)
     (NAME asdf-system-connections FILENAME asdf-system-connections)
     (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME chipz FILENAME chipz)
     (NAME chunga FILENAME chunga) (NAME cl+ssl FILENAME cl_plus_ssl)
     (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-containers FILENAME cl-containers) (NAME cl-csv FILENAME cl-csv)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-interpol FILENAME cl-interpol)
     (NAME cl-log FILENAME cl-log) (NAME cl-markdown FILENAME cl-markdown)
     (NAME cl-postgres FILENAME cl-postgres) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME closer-mop FILENAME closer-mop)
     (NAME command-line-arguments FILENAME command-line-arguments)
     (NAME db3 FILENAME db3) (NAME drakma FILENAME drakma)
     (NAME dynamic-classes FILENAME dynamic-classes)
     (NAME esrap FILENAME esrap) (NAME flexi-streams FILENAME flexi-streams)
     (NAME garbage-pools FILENAME garbage-pools)
     (NAME ieee-floats FILENAME ieee-floats) (NAME ironclad FILENAME ironclad)
     (NAME iterate FILENAME iterate) (NAME ixf FILENAME ixf)
     (NAME list-of FILENAME list-of) (NAME local-time FILENAME local-time)
     (NAME lparallel FILENAME lparallel) (NAME md5 FILENAME md5)
     (NAME metabang-bind FILENAME metabang-bind)
     (NAME metatilities-base FILENAME metatilities-base)
     (NAME mssql FILENAME mssql) (NAME nibbles FILENAME nibbles)
     (NAME parse-number FILENAME parse-number)
     (NAME postmodern FILENAME postmodern) (NAME puri FILENAME puri)
     (NAME py-configparser FILENAME py-configparser)
     (NAME qmynd FILENAME qmynd) (NAME quri FILENAME quri)
     (NAME s-sql FILENAME s-sql) (NAME salza2 FILENAME salza2)
     (NAME simple-date FILENAME simple-date)
     (NAME split-sequence FILENAME split-sequence)
     (NAME sqlite FILENAME sqlite)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-utf-8 FILENAME trivial-utf-8) (NAME uiop FILENAME uiop)
     (NAME usocket FILENAME usocket) (NAME uuid FILENAME uuid))
    DEPENDENCIES
    (abnf alexandria anaphora asdf-finalizers asdf-system-connections babel
     bordeaux-threads cffi chipz chunga cl+ssl cl-base64 cl-containers cl-csv
     cl-fad cl-interpol cl-log cl-markdown cl-postgres cl-ppcre cl-unicode
     cl-utilities closer-mop command-line-arguments db3 drakma dynamic-classes
     esrap flexi-streams garbage-pools ieee-floats ironclad iterate ixf list-of
     local-time lparallel md5 metabang-bind metatilities-base mssql nibbles
     parse-number postmodern puri py-configparser qmynd quri s-sql salza2
     simple-date split-sequence sqlite trivial-backtrace trivial-features
     trivial-garbage trivial-gray-streams trivial-utf-8 uiop usocket uuid)
    VERSION v3.4.1 SIBLINGS NIL PARASITES NIL) */
