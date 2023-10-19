/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "clack-test";
  version = "clack-20210411-git";

  description = "Testing Clack Applications.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."chipz" args."chunga" args."cl_plus_ssl" args."cl-annot" args."cl-base64" args."cl-cookie" args."cl-fad" args."cl-ppcre" args."cl-reexport" args."cl-syntax" args."cl-syntax-annot" args."cl-utilities" args."clack" args."clack-handler-hunchentoot" args."clack-socket" args."dexador" args."dissect" args."fast-http" args."fast-io" args."flexi-streams" args."http-body" args."hunchentoot" args."ironclad" args."jonathan" args."lack" args."lack-component" args."lack-middleware-backtrace" args."lack-util" args."local-time" args."md5" args."named-readtables" args."proc-parse" args."quri" args."rfc2388" args."rove" args."smart-buffer" args."split-sequence" args."static-vectors" args."trivial-backtrace" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."trivial-mimes" args."trivial-types" args."usocket" args."xsubseq" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/clack/2021-04-11/clack-20210411-git.tgz";
    sha256 = "0yai9cx1gha684ljr8k1s5n4mi6mpj2wmvv6b9iw7pw1vhw5m8mf";
  };

  packageName = "clack-test";

  asdFilesToKeep = ["clack-test.asd"];
  overrides = x: x;
}
/* (SYSTEM clack-test DESCRIPTION Testing Clack Applications. SHA256
    0yai9cx1gha684ljr8k1s5n4mi6mpj2wmvv6b9iw7pw1vhw5m8mf URL
    http://beta.quicklisp.org/archive/clack/2021-04-11/clack-20210411-git.tgz
    MD5 c47deb6287b72fc9033055914787f3a5 NAME clack-test FILENAME clack-test
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain) (NAME chipz FILENAME chipz)
     (NAME chunga FILENAME chunga) (NAME cl+ssl FILENAME cl_plus_ssl)
     (NAME cl-annot FILENAME cl-annot) (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-cookie FILENAME cl-cookie) (NAME cl-fad FILENAME cl-fad)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-reexport FILENAME cl-reexport)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME cl-utilities FILENAME cl-utilities) (NAME clack FILENAME clack)
     (NAME clack-handler-hunchentoot FILENAME clack-handler-hunchentoot)
     (NAME clack-socket FILENAME clack-socket) (NAME dexador FILENAME dexador)
     (NAME dissect FILENAME dissect) (NAME fast-http FILENAME fast-http)
     (NAME fast-io FILENAME fast-io)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME http-body FILENAME http-body)
     (NAME hunchentoot FILENAME hunchentoot) (NAME ironclad FILENAME ironclad)
     (NAME jonathan FILENAME jonathan) (NAME lack FILENAME lack)
     (NAME lack-component FILENAME lack-component)
     (NAME lack-middleware-backtrace FILENAME lack-middleware-backtrace)
     (NAME lack-util FILENAME lack-util) (NAME local-time FILENAME local-time)
     (NAME md5 FILENAME md5) (NAME named-readtables FILENAME named-readtables)
     (NAME proc-parse FILENAME proc-parse) (NAME quri FILENAME quri)
     (NAME rfc2388 FILENAME rfc2388) (NAME rove FILENAME rove)
     (NAME smart-buffer FILENAME smart-buffer)
     (NAME split-sequence FILENAME split-sequence)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-mimes FILENAME trivial-mimes)
     (NAME trivial-types FILENAME trivial-types)
     (NAME usocket FILENAME usocket) (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cffi-grovel cffi-toolchain chipz
     chunga cl+ssl cl-annot cl-base64 cl-cookie cl-fad cl-ppcre cl-reexport
     cl-syntax cl-syntax-annot cl-utilities clack clack-handler-hunchentoot
     clack-socket dexador dissect fast-http fast-io flexi-streams http-body
     hunchentoot ironclad jonathan lack lack-component
     lack-middleware-backtrace lack-util local-time md5 named-readtables
     proc-parse quri rfc2388 rove smart-buffer split-sequence static-vectors
     trivial-backtrace trivial-features trivial-garbage trivial-gray-streams
     trivial-mimes trivial-types usocket xsubseq)
    VERSION clack-20210411-git SIBLINGS
    (clack-handler-fcgi clack-handler-hunchentoot clack-handler-toot
     clack-handler-wookie clack-socket clack-v1-compat clack
     t-clack-handler-fcgi t-clack-handler-hunchentoot t-clack-handler-toot
     t-clack-handler-wookie t-clack-v1-compat clack-middleware-auth-basic
     clack-middleware-clsql clack-middleware-csrf clack-middleware-dbi
     clack-middleware-oauth clack-middleware-postmodern
     clack-middleware-rucksack clack-session-store-dbi
     t-clack-middleware-auth-basic t-clack-middleware-csrf)
    PARASITES NIL) */
