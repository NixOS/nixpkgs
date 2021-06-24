/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl_plus_ssl";
  version = "cl+ssl-20210228-git";

  description = "Common Lisp interface to OpenSSL.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."flexi-streams" args."split-sequence" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."uiop" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl+ssl/2021-02-28/cl+ssl-20210228-git.tgz";
    sha256 = "1njppcg5fm8l0lhf7nf8nfyaz9vsr922y0vfxqdp9hp7qfid8yll";
  };

  packageName = "cl+ssl";

  asdFilesToKeep = ["cl+ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256
    1njppcg5fm8l0lhf7nf8nfyaz9vsr922y0vfxqdp9hp7qfid8yll URL
    http://beta.quicklisp.org/archive/cl+ssl/2021-02-28/cl+ssl-20210228-git.tgz
    MD5 01b61fd8ee6ad8d3c1c695ba56d510b6 NAME cl+ssl FILENAME cl_plus_ssl DEPS
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
    VERSION cl+ssl-20210228-git SIBLINGS (cl+ssl.test) PARASITES NIL) */
