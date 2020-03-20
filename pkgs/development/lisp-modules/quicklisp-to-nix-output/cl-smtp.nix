args @ { fetchurl, ... }:
rec {
  baseName = ''cl-smtp'';
  version = ''20191130-git'';

  description = ''Common Lisp smtp client.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl_plus_ssl" args."cl-base64" args."flexi-streams" args."split-sequence" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-smtp/2019-11-30/cl-smtp-20191130-git.tgz'';
    sha256 = ''04x1xq1qlsnhl4wdi82l8ds6rl9rzxk72bjf2ja10jay1p6ljvdq'';
  };

  packageName = "cl-smtp";

  asdFilesToKeep = ["cl-smtp.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-smtp DESCRIPTION Common Lisp smtp client. SHA256
    04x1xq1qlsnhl4wdi82l8ds6rl9rzxk72bjf2ja10jay1p6ljvdq URL
    http://beta.quicklisp.org/archive/cl-smtp/2019-11-30/cl-smtp-20191130-git.tgz
    MD5 880f09b9fd22e358d1b94a3caf3bd34b NAME cl-smtp FILENAME cl-smtp DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cl+ssl FILENAME cl_plus_ssl)
     (NAME cl-base64 FILENAME cl-base64)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi cl+ssl cl-base64 flexi-streams
     split-sequence trivial-features trivial-garbage trivial-gray-streams
     usocket)
    VERSION 20191130-git SIBLINGS NIL PARASITES NIL) */
