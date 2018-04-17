args @ { fetchurl, ... }:
rec {
  baseName = ''cl-smtp'';
  version = ''20180131-git'';

  description = ''Common Lisp smtp client.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl_plus_ssl" args."cl-base64" args."flexi-streams" args."split-sequence" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-smtp/2018-01-31/cl-smtp-20180131-git.tgz'';
    sha256 = ''0sjjynnynxmfxdfpvzl3jj1jz0dhj0bx4bv63q1icm2p9xzfzb61'';
  };

  packageName = "cl-smtp";

  asdFilesToKeep = ["cl-smtp.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-smtp DESCRIPTION Common Lisp smtp client. SHA256
    0sjjynnynxmfxdfpvzl3jj1jz0dhj0bx4bv63q1icm2p9xzfzb61 URL
    http://beta.quicklisp.org/archive/cl-smtp/2018-01-31/cl-smtp-20180131-git.tgz
    MD5 0ce08f067f145ab4c7528f806f0b51ff NAME cl-smtp FILENAME cl-smtp DEPS
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
    VERSION 20180131-git SIBLINGS NIL PARASITES NIL) */
