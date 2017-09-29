args @ { fetchurl, ... }:
rec {
  baseName = ''dexador'';
  version = ''20170725-git'';

  description = ''Yet another HTTP client for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."chipz" args."chunga" args."cl+ssl" args."cl-base64" args."cl-cookie" args."cl-fad" args."cl-ppcre" args."cl-reexport" args."cl-utilities" args."fast-http" args."fast-io" args."flexi-streams" args."local-time" args."proc-parse" args."quri" args."smart-buffer" args."split-sequence" args."static-vectors" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."trivial-mimes" args."usocket" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/dexador/2017-07-25/dexador-20170725-git.tgz'';
    sha256 = ''1x5jw07ydvc7rdw4jyzf3zb2dg2mspbkp9ysjaqpxlvkpdmqdmyl'';
  };

  packageName = "dexador";

  asdFilesToKeep = ["dexador.asd"];
  overrides = x: x;
}
/* (SYSTEM dexador DESCRIPTION Yet another HTTP client for Common Lisp SHA256
    1x5jw07ydvc7rdw4jyzf3zb2dg2mspbkp9ysjaqpxlvkpdmqdmyl URL
    http://beta.quicklisp.org/archive/dexador/2017-07-25/dexador-20170725-git.tgz
    MD5 1ab5cda1ba8d5c81859349e6a5b99b29 NAME dexador FILENAME dexador DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME chipz FILENAME chipz)
     (NAME chunga FILENAME chunga) (NAME cl+ssl FILENAME cl+ssl)
     (NAME cl-base64 FILENAME cl-base64) (NAME cl-cookie FILENAME cl-cookie)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-reexport FILENAME cl-reexport)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME fast-http FILENAME fast-http) (NAME fast-io FILENAME fast-io)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME local-time FILENAME local-time)
     (NAME proc-parse FILENAME proc-parse) (NAME quri FILENAME quri)
     (NAME smart-buffer FILENAME smart-buffer)
     (NAME split-sequence FILENAME split-sequence)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-mimes FILENAME trivial-mimes)
     (NAME usocket FILENAME usocket) (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi chipz chunga cl+ssl cl-base64
     cl-cookie cl-fad cl-ppcre cl-reexport cl-utilities fast-http fast-io
     flexi-streams local-time proc-parse quri smart-buffer split-sequence
     static-vectors trivial-features trivial-garbage trivial-gray-streams
     trivial-mimes usocket xsubseq)
    VERSION 20170725-git SIBLINGS (dexador-test) PARASITES NIL) */
