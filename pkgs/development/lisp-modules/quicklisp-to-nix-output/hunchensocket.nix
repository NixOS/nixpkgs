/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "hunchensocket";
  version = "20180711-git";

  parasites = [ "hunchensocket-tests" ];

  description = "WebSockets for Hunchentoot";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."chunga" args."cl_plus_ssl" args."cl-base64" args."cl-fad" args."cl-ppcre" args."fiasco" args."flexi-streams" args."hunchentoot" args."ironclad" args."md5" args."rfc2388" args."split-sequence" args."trivial-backtrace" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."trivial-utf-8" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/hunchensocket/2018-07-11/hunchensocket-20180711-git.tgz";
    sha256 = "03igrp8svb4gkwhhhgmxwrnp5vq5ndp15mxqsafyi065xj3ppw48";
  };

  packageName = "hunchensocket";

  asdFilesToKeep = ["hunchensocket.asd"];
  overrides = x: x;
}
/* (SYSTEM hunchensocket DESCRIPTION WebSockets for Hunchentoot SHA256
    03igrp8svb4gkwhhhgmxwrnp5vq5ndp15mxqsafyi065xj3ppw48 URL
    http://beta.quicklisp.org/archive/hunchensocket/2018-07-11/hunchensocket-20180711-git.tgz
    MD5 bf6cd52c13e3b1f464c8a45a8bac85b8 NAME hunchensocket FILENAME
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
    VERSION 20180711-git SIBLINGS NIL PARASITES (hunchensocket-tests)) */
