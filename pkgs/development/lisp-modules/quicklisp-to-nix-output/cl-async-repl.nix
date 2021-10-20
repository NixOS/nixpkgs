/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-async-repl";
  version = "cl-async-20210531-git";

  description = "REPL integration for CL-ASYNC.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-async" args."cl-async-base" args."cl-async-util" args."cl-libuv" args."cl-ppcre" args."fast-io" args."static-vectors" args."trivial-features" args."trivial-gray-streams" args."vom" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-async/2021-05-31/cl-async-20210531-git.tgz";
    sha256 = "0hvgxkdvz1hz9ysyajlsnckcypfqka6h5payy3chxbnbvis4kkqw";
  };

  packageName = "cl-async-repl";

  asdFilesToKeep = ["cl-async-repl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-async-repl DESCRIPTION REPL integration for CL-ASYNC. SHA256
    0hvgxkdvz1hz9ysyajlsnckcypfqka6h5payy3chxbnbvis4kkqw URL
    http://beta.quicklisp.org/archive/cl-async/2021-05-31/cl-async-20210531-git.tgz
    MD5 bf2b1337e09df5ecca329c3e92622376 NAME cl-async-repl FILENAME
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
    VERSION cl-async-20210531-git SIBLINGS
    (cl-async-ssl cl-async-test cl-async) PARASITES NIL) */
