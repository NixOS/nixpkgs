args @ { fetchurl, ... }:
rec {
  baseName = ''hunchentoot'';
  version = ''v1.2.37'';

  parasites = [ "hunchentoot-dev" "hunchentoot-test" ];

  description = ''Hunchentoot is a HTTP server based on USOCKET and
  BORDEAUX-THREADS.  It supports HTTP 1.1, serves static files, has a
  simple framework for user-defined handlers and can be extended
  through subclassing.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."chunga" args."cl+ssl" args."cl-base64" args."cl-fad" args."cl-ppcre" args."cl-who" args."cxml-stp" args."drakma" args."flexi-streams" args."md5" args."rfc2388" args."split-sequence" args."swank" args."trivial-backtrace" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."usocket" args."xpath" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hunchentoot/2017-07-25/hunchentoot-v1.2.37.tgz'';
    sha256 = ''1r0p8qasd2zy9a8l58jysz5bb1gj79cz2ikr93in0my8q44pg9lc'';
  };

  packageName = "hunchentoot";

  asdFilesToKeep = ["hunchentoot.asd"];
  overrides = x: x;
}
/* (SYSTEM hunchentoot DESCRIPTION
    Hunchentoot is a HTTP server based on USOCKET and
  BORDEAUX-THREADS.  It supports HTTP 1.1, serves static files, has a
  simple framework for user-defined handlers and can be extended
  through subclassing.
    SHA256 1r0p8qasd2zy9a8l58jysz5bb1gj79cz2ikr93in0my8q44pg9lc URL
    http://beta.quicklisp.org/archive/hunchentoot/2017-07-25/hunchentoot-v1.2.37.tgz
    MD5 3fd6a6c4dd0d32db7b71828b52494325 NAME hunchentoot FILENAME hunchentoot
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME chunga FILENAME chunga)
     (NAME cl+ssl FILENAME cl+ssl) (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-who FILENAME cl-who) (NAME cxml-stp FILENAME cxml-stp)
     (NAME drakma FILENAME drakma) (NAME flexi-streams FILENAME flexi-streams)
     (NAME md5 FILENAME md5) (NAME rfc2388 FILENAME rfc2388)
     (NAME split-sequence FILENAME split-sequence) (NAME swank FILENAME swank)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME usocket FILENAME usocket) (NAME xpath FILENAME xpath))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi chunga cl+ssl cl-base64 cl-fad
     cl-ppcre cl-who cxml-stp drakma flexi-streams md5 rfc2388 split-sequence
     swank trivial-backtrace trivial-features trivial-garbage
     trivial-gray-streams usocket xpath)
    VERSION v1.2.37 SIBLINGS NIL PARASITES (hunchentoot-dev hunchentoot-test)) */
