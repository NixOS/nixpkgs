/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hunchensocket";
  version = "20210531-git";

  parasites = [ "hunchensocket-tests" ];

  description = "WebSockets for Hunchentoot";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."chunga" args."cl_plus_ssl" args."cl-base64" args."cl-fad" args."cl-ppcre" args."fiasco" args."flexi-streams" args."hunchentoot" args."ironclad" args."md5" args."rfc2388" args."split-sequence" args."trivial-backtrace" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."trivial-utf-8" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hunchensocket/2021-05-31/hunchensocket-20210531-git.tgz";
    sha256 = "18zy11fir6vlg5vh29pr221dydbl9carfj9xkmsnygyzxkl6jghl";
  };

  packageName = "hunchensocket";

  asdFilesToKeep = ["hunchensocket.asd"];
  overrides = x: x;
}
/* (SYSTEM hunchensocket DESCRIPTION WebSockets for Hunchentoot SHA256
    18zy11fir6vlg5vh29pr221dydbl9carfj9xkmsnygyzxkl6jghl URL
    http://beta.quicklisp.org/archive/hunchensocket/2021-05-31/hunchensocket-20210531-git.tgz
    MD5 a529901753a54eb48c93aa86b0c3747d NAME hunchensocket FILENAME
    hunchensocket DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME chunga FILENAME chunga)
     (NAME cl+ssl FILENAME cl_plus_ssl) (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME fiasco FILENAME fiasco) (NAME flexi-streams FILENAME flexi-streams)
     (NAME hunchentoot FILENAME hunchentoot) (NAME ironclad FILENAME ironclad)
     (NAME md5 FILENAME md5) (NAME rfc2388 FILENAME rfc2388)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-backtrace FILENAME trivial-backtrace)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-utf-8 FILENAME trivial-utf-8)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi chunga cl+ssl cl-base64 cl-fad
     cl-ppcre fiasco flexi-streams hunchentoot ironclad md5 rfc2388
     split-sequence trivial-backtrace trivial-features trivial-garbage
     trivial-gray-streams trivial-utf-8 usocket)
    VERSION 20210531-git SIBLINGS NIL PARASITES (hunchensocket-tests)) */
