args @ { fetchurl, ... }:
rec {
  baseName = ''cl-async-ssl'';
  version = ''cl-async-20160825-git'';

  description = ''SSL Wrapper around cl-async socket implementation.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cffi-grovel" args."cl-async" args."cl-async-base" args."cl-async-util" args."cl-libuv" args."cl-ppcre" args."fast-io" args."static-vectors" args."trivial-features" args."trivial-gray-streams" args."vom" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz'';
    sha256 = ''104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa'';
  };

  packageName = "cl-async-ssl";

  asdFilesToKeep = ["cl-async-ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-async-ssl DESCRIPTION
    SSL Wrapper around cl-async socket implementation. SHA256
    104x6vw9zrmzz3sipmzn0ygil6ccyy8gpvvjxak2bfxbmxcl09pa URL
    http://beta.quicklisp.org/archive/cl-async/2016-08-25/cl-async-20160825-git.tgz
    MD5 18e1d6c54a27c8ba721ebaa3d8c6e112 NAME cl-async-ssl FILENAME
    cl-async-ssl DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
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
    (alexandria babel bordeaux-threads cffi cffi-grovel cl-async cl-async-base
     cl-async-util cl-libuv cl-ppcre fast-io static-vectors trivial-features
     trivial-gray-streams vom)
    VERSION cl-async-20160825-git SIBLINGS
    (cl-async-repl cl-async-test cl-async) PARASITES NIL) */
