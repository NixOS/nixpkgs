args @ { fetchurl, ... }:
rec {
  baseName = ''wookie'';
  version = ''20180831-git'';

  description = ''An evented webserver for Common Lisp.'';

  deps = [ args."alexandria" args."babel" args."babel-streams" args."blackbird" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."chunga" args."cl-async" args."cl-async-base" args."cl-async-ssl" args."cl-async-util" args."cl-fad" args."cl-libuv" args."cl-ppcre" args."cl-utilities" args."do-urlencode" args."fast-http" args."fast-io" args."flexi-streams" args."proc-parse" args."quri" args."smart-buffer" args."split-sequence" args."static-vectors" args."trivial-features" args."trivial-gray-streams" args."vom" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/wookie/2018-08-31/wookie-20180831-git.tgz'';
    sha256 = ''1hy6hdfhdfnyd00q3v7ryjqvq7x8j22yy4l52p24jj0n19mx3pjx'';
  };

  packageName = "wookie";

  asdFilesToKeep = ["wookie.asd"];
  overrides = x: x;
}
/* (SYSTEM wookie DESCRIPTION An evented webserver for Common Lisp. SHA256
    1hy6hdfhdfnyd00q3v7ryjqvq7x8j22yy4l52p24jj0n19mx3pjx URL
    http://beta.quicklisp.org/archive/wookie/2018-08-31/wookie-20180831-git.tgz
    MD5 c825760241580a95c68b1ac6f428e07e NAME wookie FILENAME wookie DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME babel-streams FILENAME babel-streams)
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
    (alexandria babel babel-streams blackbird bordeaux-threads cffi cffi-grovel
     cffi-toolchain chunga cl-async cl-async-base cl-async-ssl cl-async-util
     cl-fad cl-libuv cl-ppcre cl-utilities do-urlencode fast-http fast-io
     flexi-streams proc-parse quri smart-buffer split-sequence static-vectors
     trivial-features trivial-gray-streams vom xsubseq)
    VERSION 20180831-git SIBLINGS NIL PARASITES NIL) */
