args @ { fetchurl, ... }:
rec {
  baseName = ''clack-v1-compat'';
  version = ''clack-20180831-git'';

  description = '''';

  deps = [ args."alexandria" args."anaphora" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."chipz" args."chunga" args."circular-streams" args."cl_plus_ssl" args."cl-annot" args."cl-ansi-text" args."cl-base64" args."cl-colors" args."cl-cookie" args."cl-fad" args."cl-ppcre" args."cl-reexport" args."cl-syntax" args."cl-syntax-annot" args."cl-utilities" args."clack" args."clack-handler-hunchentoot" args."clack-socket" args."clack-test" args."dexador" args."fast-http" args."fast-io" args."flexi-streams" args."http-body" args."hunchentoot" args."ironclad" args."jonathan" args."lack" args."lack-component" args."lack-middleware-backtrace" args."lack-util" args."let-plus" args."local-time" args."marshal" args."md5" args."named-readtables" args."nibbles" args."proc-parse" args."prove" args."quri" args."rfc2388" args."smart-buffer" args."split-sequence" args."static-vectors" args."trivial-backtrace" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."trivial-mimes" args."trivial-types" args."uiop" args."usocket" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clack/2018-08-31/clack-20180831-git.tgz'';
    sha256 = ''0pfpm3l7l47j0mmwimy7c61ym8lg5m1dkzmz394snyywzcx54647'';
  };

  packageName = "clack-v1-compat";

  asdFilesToKeep = ["clack-v1-compat.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-v1-compat DESCRIPTION NIL SHA256
    0pfpm3l7l47j0mmwimy7c61ym8lg5m1dkzmz394snyywzcx54647 URL
    http://beta.quicklisp.org/archive/clack/2018-08-31/clack-20180831-git.tgz
    MD5 5042ece3b0a8b07cb4b318fbc250b4fe NAME clack-v1-compat FILENAME
    clack-v1-compat DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain) (NAME chipz FILENAME chipz)
     (NAME chunga FILENAME chunga)
     (NAME circular-streams FILENAME circular-streams)
     (NAME cl+ssl FILENAME cl_plus_ssl) (NAME cl-annot FILENAME cl-annot)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-base64 FILENAME cl-base64) (NAME cl-colors FILENAME cl-colors)
     (NAME cl-cookie FILENAME cl-cookie) (NAME cl-fad FILENAME cl-fad)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-reexport FILENAME cl-reexport)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME cl-utilities FILENAME cl-utilities) (NAME clack FILENAME clack)
     (NAME clack-handler-hunchentoot FILENAME clack-handler-hunchentoot)
     (NAME clack-socket FILENAME clack-socket)
     (NAME clack-test FILENAME clack-test) (NAME dexador FILENAME dexador)
     (NAME fast-http FILENAME fast-http) (NAME fast-io FILENAME fast-io)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME http-body FILENAME http-body)
     (NAME hunchentoot FILENAME hunchentoot) (NAME ironclad FILENAME ironclad)
     (NAME jonathan FILENAME jonathan) (NAME lack FILENAME lack)
     (NAME lack-component FILENAME lack-component)
     (NAME lack-middleware-backtrace FILENAME lack-middleware-backtrace)
     (NAME lack-util FILENAME lack-util) (NAME let-plus FILENAME let-plus)
     (NAME local-time FILENAME local-time) (NAME marshal FILENAME marshal)
     (NAME md5 FILENAME md5) (NAME named-readtables FILENAME named-readtables)
     (NAME nibbles FILENAME nibbles) (NAME proc-parse FILENAME proc-parse)
     (NAME prove FILENAME prove) (NAME quri FILENAME quri)
     (NAME rfc2388 FILENAME rfc2388) (NAME smart-buffer FILENAME smart-buffer)
     (NAME split-sequence FILENAME split-sequence)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-mimes FILENAME trivial-mimes)
     (NAME trivial-types FILENAME trivial-types) (NAME uiop FILENAME uiop)
     (NAME usocket FILENAME usocket) (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES
    (alexandria anaphora babel bordeaux-threads cffi cffi-grovel cffi-toolchain
     chipz chunga circular-streams cl+ssl cl-annot cl-ansi-text cl-base64
     cl-colors cl-cookie cl-fad cl-ppcre cl-reexport cl-syntax cl-syntax-annot
     cl-utilities clack clack-handler-hunchentoot clack-socket clack-test
     dexador fast-http fast-io flexi-streams http-body hunchentoot ironclad
     jonathan lack lack-component lack-middleware-backtrace lack-util let-plus
     local-time marshal md5 named-readtables nibbles proc-parse prove quri
     rfc2388 smart-buffer split-sequence static-vectors trivial-backtrace
     trivial-features trivial-garbage trivial-gray-streams trivial-mimes
     trivial-types uiop usocket xsubseq)
    VERSION clack-20180831-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-socket clack-test clack t-clack-handler-fcgi
     t-clack-handler-hunchentoot t-clack-handler-toot t-clack-handler-wookie
     t-clack-v1-compat clack-middleware-auth-basic clack-middleware-clsql
     clack-middleware-csrf clack-middleware-dbi clack-middleware-oauth
     clack-middleware-postmodern clack-middleware-rucksack
     clack-session-store-dbi t-clack-middleware-auth-basic
     t-clack-middleware-csrf)
    PARASITES NIL) */
