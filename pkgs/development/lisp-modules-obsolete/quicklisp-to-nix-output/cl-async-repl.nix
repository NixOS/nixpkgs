/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-async-repl";
  version = "cl-async-20211020-git";

  description = "REPL integration for CL-ASYNC.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-async" args."cl-async-base" args."cl-async-util" args."cl-libuv" args."cl-ppcre" args."fast-io" args."static-vectors" args."trivial-features" args."trivial-gray-streams" args."vom" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-async/2021-10-20/cl-async-20211020-git.tgz";
    sha256 = "1b3bwqvzw2pc83m4x8vbbxyriq58g0j3738mzq68v689zl071dl0";
  };

  packageName = "cl-async-repl";

  asdFilesToKeep = ["cl-async-repl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-async-repl DESCRIPTION REPL integration for CL-ASYNC. SHA256
    1b3bwqvzw2pc83m4x8vbbxyriq58g0j3738mzq68v689zl071dl0 URL
    http://beta.quicklisp.org/archive/cl-async/2021-10-20/cl-async-20211020-git.tgz
    MD5 0e0cd11758e93a91b39ad726fb1051cc NAME cl-async-repl FILENAME
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
    VERSION cl-async-20211020-git SIBLINGS
    (cl-async-ssl cl-async-test cl-async) PARASITES NIL) */
