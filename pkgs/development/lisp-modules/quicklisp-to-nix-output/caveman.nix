args @ { fetchurl, ... }:
rec {
  baseName = ''caveman'';
  version = ''20190813-git'';

  description = ''Web Application Framework for Common Lisp'';

  deps = [ args."alexandria" args."anaphora" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."chipz" args."chunga" args."circular-streams" args."cl_plus_ssl" args."cl-annot" args."cl-ansi-text" args."cl-base64" args."cl-colors" args."cl-cookie" args."cl-emb" args."cl-fad" args."cl-ppcre" args."cl-project" args."cl-reexport" args."cl-syntax" args."cl-syntax-annot" args."cl-utilities" args."clack" args."clack-handler-hunchentoot" args."clack-socket" args."clack-test" args."clack-v1-compat" args."dexador" args."dissect" args."do-urlencode" args."fast-http" args."fast-io" args."flexi-streams" args."http-body" args."hunchentoot" args."ironclad" args."jonathan" args."lack" args."lack-component" args."lack-middleware-backtrace" args."lack-util" args."let-plus" args."local-time" args."map-set" args."marshal" args."md5" args."myway" args."named-readtables" args."nibbles" args."proc-parse" args."prove" args."quri" args."rfc2388" args."rove" args."smart-buffer" args."split-sequence" args."static-vectors" args."trivial-backtrace" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."trivial-mimes" args."trivial-types" args."usocket" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/caveman/2019-08-13/caveman-20190813-git.tgz'';
    sha256 = ''017b3g3vm28awv8s68rwkwri7yq31a6lgdd7114ziis2a9fq9hyd'';
  };

  packageName = "caveman";

  asdFilesToKeep = ["caveman.asd"];
  overrides = x: x;
}
/* (SYSTEM caveman DESCRIPTION Web Application Framework for Common Lisp SHA256
    017b3g3vm28awv8s68rwkwri7yq31a6lgdd7114ziis2a9fq9hyd URL
    http://beta.quicklisp.org/archive/caveman/2019-08-13/caveman-20190813-git.tgz
    MD5 09d7223fd528757eaf1285dd99105ed6 NAME caveman FILENAME caveman DEPS
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
     (NAME cl-cookie FILENAME cl-cookie) (NAME cl-emb FILENAME cl-emb)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-project FILENAME cl-project)
     (NAME cl-reexport FILENAME cl-reexport)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME cl-utilities FILENAME cl-utilities) (NAME clack FILENAME clack)
     (NAME clack-handler-hunchentoot FILENAME clack-handler-hunchentoot)
     (NAME clack-socket FILENAME clack-socket)
     (NAME clack-test FILENAME clack-test)
     (NAME clack-v1-compat FILENAME clack-v1-compat)
     (NAME dexador FILENAME dexador) (NAME dissect FILENAME dissect)
     (NAME do-urlencode FILENAME do-urlencode)
     (NAME fast-http FILENAME fast-http) (NAME fast-io FILENAME fast-io)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME http-body FILENAME http-body)
     (NAME hunchentoot FILENAME hunchentoot) (NAME ironclad FILENAME ironclad)
     (NAME jonathan FILENAME jonathan) (NAME lack FILENAME lack)
     (NAME lack-component FILENAME lack-component)
     (NAME lack-middleware-backtrace FILENAME lack-middleware-backtrace)
     (NAME lack-util FILENAME lack-util) (NAME let-plus FILENAME let-plus)
     (NAME local-time FILENAME local-time) (NAME map-set FILENAME map-set)
     (NAME marshal FILENAME marshal) (NAME md5 FILENAME md5)
     (NAME myway FILENAME myway)
     (NAME named-readtables FILENAME named-readtables)
     (NAME nibbles FILENAME nibbles) (NAME proc-parse FILENAME proc-parse)
     (NAME prove FILENAME prove) (NAME quri FILENAME quri)
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
    (alexandria anaphora babel bordeaux-threads cffi cffi-grovel cffi-toolchain
     chipz chunga circular-streams cl+ssl cl-annot cl-ansi-text cl-base64
     cl-colors cl-cookie cl-emb cl-fad cl-ppcre cl-project cl-reexport
     cl-syntax cl-syntax-annot cl-utilities clack clack-handler-hunchentoot
     clack-socket clack-test clack-v1-compat dexador dissect do-urlencode
     fast-http fast-io flexi-streams http-body hunchentoot ironclad jonathan
     lack lack-component lack-middleware-backtrace lack-util let-plus
     local-time map-set marshal md5 myway named-readtables nibbles proc-parse
     prove quri rfc2388 rove smart-buffer split-sequence static-vectors
     trivial-backtrace trivial-features trivial-garbage trivial-gray-streams
     trivial-mimes trivial-types usocket xsubseq)
    VERSION 20190813-git SIBLINGS
    (caveman-middleware-dbimanager caveman-test caveman2-db caveman2-test
     caveman2)
    PARASITES NIL) */
