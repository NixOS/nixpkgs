/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-smtp";
  version = "20210228-git";

  description = "Common Lisp smtp client.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl_plus_ssl" args."cl-base64" args."flexi-streams" args."split-sequence" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-smtp/2021-02-28/cl-smtp-20210228-git.tgz";
    sha256 = "1x965jyhifx8hss2v6qc6lr54nlckchs712dny376krwkl43jh5g";
  };

  packageName = "cl-smtp";

  asdFilesToKeep = ["cl-smtp.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-smtp DESCRIPTION Common Lisp smtp client. SHA256
    1x965jyhifx8hss2v6qc6lr54nlckchs712dny376krwkl43jh5g URL
    http://beta.quicklisp.org/archive/cl-smtp/2021-02-28/cl-smtp-20210228-git.tgz
    MD5 e2f9137807f80514e0433bf2e8522ee5 NAME cl-smtp FILENAME cl-smtp DEPS
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
    VERSION 20210228-git SIBLINGS NIL PARASITES NIL) */
