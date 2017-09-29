args @ { fetchurl, ... }:
rec {
  baseName = ''cl-smtp'';
  version = ''20160825-git'';

  description = ''Common Lisp smtp client.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."cl+ssl" args."cl-base64" args."flexi-streams" args."split-sequence" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-smtp/2016-08-25/cl-smtp-20160825-git.tgz'';
    sha256 = ''0svkvy6x458a7rgvp3wki0lmhdxpaa1j0brwsw2mlpl2jqkx5dxh'';
  };

  packageName = "cl-smtp";

  asdFilesToKeep = ["cl-smtp.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-smtp DESCRIPTION Common Lisp smtp client. SHA256
    0svkvy6x458a7rgvp3wki0lmhdxpaa1j0brwsw2mlpl2jqkx5dxh URL
    http://beta.quicklisp.org/archive/cl-smtp/2016-08-25/cl-smtp-20160825-git.tgz
    MD5 e6bb60e66b0f7d9cc5e4f98aba56998a NAME cl-smtp FILENAME cl-smtp DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cffi FILENAME cffi) (NAME cl+ssl FILENAME cl+ssl)
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
    VERSION 20160825-git SIBLINGS NIL PARASITES NIL) */
