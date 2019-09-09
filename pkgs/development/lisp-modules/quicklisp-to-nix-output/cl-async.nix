args @ { fetchurl, ... }:
{
  baseName = ''cl-async'';
  version = ''20190307-git'';

  parasites = [ "cl-async-base" "cl-async-util" ];

  description = ''Asynchronous operations for Common Lisp.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-libuv" args."cl-ppcre" args."fast-io" args."static-vectors" args."trivial-features" args."trivial-gray-streams" args."uiop" args."vom" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-async/2019-03-07/cl-async-20190307-git.tgz'';
    sha256 = ''1sgqdz1dqhknh92l39w67931kml6v9c5yj0brx7lb18l1z76ycw6'';
  };

  packageName = "cl-async";

  asdFilesToKeep = ["cl-async.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-async DESCRIPTION Asynchronous operations for Common Lisp. SHA256
    1sgqdz1dqhknh92l39w67931kml6v9c5yj0brx7lb18l1z76ycw6 URL
    http://beta.quicklisp.org/archive/cl-async/2019-03-07/cl-async-20190307-git.tgz
    MD5 ead46ad0e709ce26489eb8b239bdbd0e NAME cl-async FILENAME cl-async DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME cl-libuv FILENAME cl-libuv) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME fast-io FILENAME fast-io)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME uiop FILENAME uiop) (NAME vom FILENAME vom))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cffi-grovel cffi-toolchain cl-libuv
     cl-ppcre fast-io static-vectors trivial-features trivial-gray-streams uiop
     vom)
    VERSION 20190307-git SIBLINGS (cl-async-repl cl-async-ssl cl-async-test)
    PARASITES (cl-async-base cl-async-util)) */
