args @ { fetchurl, ... }:
rec {
  baseName = ''hunchentoot'';
  version = ''v1.2.38'';

  parasites = [ "hunchentoot-dev" "hunchentoot-test" ];

  description = ''Hunchentoot is a HTTP server based on USOCKET and
  BORDEAUX-THREADS.  It supports HTTP 1.1, serves static files, has a
  simple framework for user-defined handlers and can be extended
  through subclassing.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."chunga" args."cl_plus_ssl" args."cl-base64" args."cl-fad" args."cl-ppcre" args."cl-who" args."cxml-stp" args."drakma" args."flexi-streams" args."md5" args."rfc2388" args."split-sequence" args."swank" args."trivial-backtrace" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."usocket" args."xpath" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/hunchentoot/2017-12-27/hunchentoot-v1.2.38.tgz'';
    sha256 = ''1d3gnqbk2s3g9q51sx8mcsp2rmbvcfanbnljsf19npgfmz1ypsgd'';
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
    SHA256 1d3gnqbk2s3g9q51sx8mcsp2rmbvcfanbnljsf19npgfmz1ypsgd URL
    http://beta.quicklisp.org/archive/hunchentoot/2017-12-27/hunchentoot-v1.2.38.tgz
    MD5 878a7833eb34a53231011b78e998e2fa NAME hunchentoot FILENAME hunchentoot
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME chunga FILENAME chunga)
     (NAME cl+ssl FILENAME cl_plus_ssl) (NAME cl-base64 FILENAME cl-base64)
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
    VERSION v1.2.38 SIBLINGS NIL PARASITES (hunchentoot-dev hunchentoot-test)) */
