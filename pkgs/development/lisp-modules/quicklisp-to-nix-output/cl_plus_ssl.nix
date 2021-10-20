/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl_plus_ssl";
  version = "cl+ssl-20210807-git";

  description = "Common Lisp interface to OpenSSL.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."flexi-streams" args."split-sequence" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."uiop" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl+ssl/2021-08-07/cl+ssl-20210807-git.tgz";
    sha256 = "04kk392r7w5xq414vaf3wnkrlhczdn863x3jj3vmrp7ppr9cwy57";
  };

  packageName = "cl+ssl";

  asdFilesToKeep = ["cl+ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256
    04kk392r7w5xq414vaf3wnkrlhczdn863x3jj3vmrp7ppr9cwy57 URL
    http://beta.quicklisp.org/archive/cl+ssl/2021-08-07/cl+ssl-20210807-git.tgz
    MD5 d2267b96fcd5ee4ad2f9fc11a7a3f0b2 NAME cl+ssl FILENAME cl_plus_ssl DEPS
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
    VERSION cl+ssl-20210807-git SIBLINGS (cl+ssl.test) PARASITES NIL) */
