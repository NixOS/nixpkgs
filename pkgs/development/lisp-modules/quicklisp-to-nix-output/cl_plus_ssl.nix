/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl_plus_ssl";
  version = "cl+ssl-20211209-git";

  parasites = [ "cl+ssl/config" ];

  description = "Common Lisp interface to OpenSSL.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."flexi-streams" args."split-sequence" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."uiop" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl+ssl/2021-12-09/cl+ssl-20211209-git.tgz";
    sha256 = "1m1dx4jfqpd2jdica7safq3fig31xyn96a0yslvszbhkyn22r0nb";
  };

  packageName = "cl+ssl";

  asdFilesToKeep = ["cl+ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256
    1m1dx4jfqpd2jdica7safq3fig31xyn96a0yslvszbhkyn22r0nb URL
    http://beta.quicklisp.org/archive/cl+ssl/2021-12-09/cl+ssl-20211209-git.tgz
    MD5 900134876fea38710e6535420ec60864 NAME cl+ssl FILENAME cl_plus_ssl DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME flexi-streams FILENAME flexi-streams)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-garbage FILENAME trivial-garbage)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME uiop FILENAME uiop) (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cffi flexi-streams split-sequence
     trivial-features trivial-garbage trivial-gray-streams uiop usocket)
    VERSION cl+ssl-20211209-git SIBLINGS (cl+ssl.test) PARASITES
    (cl+ssl/config)) */
