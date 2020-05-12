args @ { fetchurl, ... }:
rec {
  baseName = ''cl-async-repl'';
  version = ''cl-async-20191130-git'';

  description = ''REPL integration for CL-ASYNC.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-async" args."cl-async-base" args."cl-async-util" args."cl-libuv" args."cl-ppcre" args."fast-io" args."static-vectors" args."trivial-features" args."trivial-gray-streams" args."vom" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-async/2019-11-30/cl-async-20191130-git.tgz'';
    sha256 = ''01kadvflif18f4i2l8iwx9jpg9543hrxagv4ad4q1k9500078vv2'';
  };

  packageName = "cl-async-repl";

  asdFilesToKeep = ["cl-async-repl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-async-repl DESCRIPTION REPL integration for CL-ASYNC. SHA256
    01kadvflif18f4i2l8iwx9jpg9543hrxagv4ad4q1k9500078vv2 URL
    http://beta.quicklisp.org/archive/cl-async/2019-11-30/cl-async-20191130-git.tgz
    MD5 3850bc827b4c41b6047b962e3892bcb2 NAME cl-async-repl FILENAME
    cl-async-repl DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME cl-async FILENAME cl-async)
     (NAME cl-async-base FILENAME cl-async-base)
     (NAME cl-async-util FILENAME cl-async-util)
     (NAME cl-libuv FILENAME cl-libuv) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME fast-io FILENAME fast-io)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME vom FILENAME vom))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cffi-grovel cffi-toolchain cl-async
     cl-async-base cl-async-util cl-libuv cl-ppcre fast-io static-vectors
     trivial-features trivial-gray-streams vom)
    VERSION cl-async-20191130-git SIBLINGS
    (cl-async-ssl cl-async-test cl-async) PARASITES NIL) */
