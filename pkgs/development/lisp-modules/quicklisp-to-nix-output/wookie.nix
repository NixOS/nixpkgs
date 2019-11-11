args @ { fetchurl, ... }:
rec {
  baseName = ''wookie'';
  version = ''20181018-git'';

  description = ''An evented webserver for Common Lisp.'';

  deps = [ args."alexandria" args."babel" args."blackbird" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."chunga" args."cl-async" args."cl-async-base" args."cl-async-ssl" args."cl-async-util" args."cl-fad" args."cl-libuv" args."cl-ppcre" args."cl-utilities" args."do-urlencode" args."fast-http" args."fast-io" args."flexi-streams" args."proc-parse" args."quri" args."smart-buffer" args."split-sequence" args."static-vectors" args."trivial-features" args."trivial-gray-streams" args."vom" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/wookie/2018-10-18/wookie-20181018-git.tgz'';
    sha256 = ''0z7v7fg9dm6g4kdvfi588vnfh0dv2knb0z3rf5a9fw8yrvckifdq'';
  };

  packageName = "wookie";

  asdFilesToKeep = ["wookie.asd"];
  overrides = x: x;
}
/* (SYSTEM wookie DESCRIPTION An evented webserver for Common Lisp. SHA256
    0z7v7fg9dm6g4kdvfi588vnfh0dv2knb0z3rf5a9fw8yrvckifdq URL
    http://beta.quicklisp.org/archive/wookie/2018-10-18/wookie-20181018-git.tgz
    MD5 91e350e5aca3c3a5c56371bff8f754ae NAME wookie FILENAME wookie DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME blackbird FILENAME blackbird)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME chunga FILENAME chunga) (NAME cl-async FILENAME cl-async)
     (NAME cl-async-base FILENAME cl-async-base)
     (NAME cl-async-ssl FILENAME cl-async-ssl)
     (NAME cl-async-util FILENAME cl-async-util) (NAME cl-fad FILENAME cl-fad)
     (NAME cl-libuv FILENAME cl-libuv) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME do-urlencode FILENAME do-urlencode)
     (NAME fast-http FILENAME fast-http) (NAME fast-io FILENAME fast-io)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME proc-parse FILENAME proc-parse) (NAME quri FILENAME quri)
     (NAME smart-buffer FILENAME smart-buffer)
     (NAME split-sequence FILENAME split-sequence)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME vom FILENAME vom) (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES
    (alexandria babel blackbird bordeaux-threads cffi cffi-grovel
     cffi-toolchain chunga cl-async cl-async-base cl-async-ssl cl-async-util
     cl-fad cl-libuv cl-ppcre cl-utilities do-urlencode fast-http fast-io
     flexi-streams proc-parse quri smart-buffer split-sequence static-vectors
     trivial-features trivial-gray-streams vom xsubseq)
    VERSION 20181018-git SIBLINGS NIL PARASITES NIL) */
