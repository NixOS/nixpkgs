/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl_plus_ssl";
  version = "cl+ssl-20210411-git";

  description = "Common Lisp interface to OpenSSL.";

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."flexi-streams" args."split-sequence" args."trivial-features" args."trivial-garbage" args."trivial-gray-streams" args."uiop" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl+ssl/2021-04-11/cl+ssl-20210411-git.tgz";
    sha256 = "1rc13lc5wwzlkn7yhl3bwl6cmxxldmbfnz52nz5b83v4wlw2zbcw";
  };

  packageName = "cl+ssl";

  asdFilesToKeep = ["cl+ssl.asd"];
  overrides = x: x;
}
/* (SYSTEM cl+ssl DESCRIPTION Common Lisp interface to OpenSSL. SHA256
    1rc13lc5wwzlkn7yhl3bwl6cmxxldmbfnz52nz5b83v4wlw2zbcw URL
    http://beta.quicklisp.org/archive/cl+ssl/2021-04-11/cl+ssl-20210411-git.tgz
    MD5 9ef5b60ac4c8ad4f435a3ef6234897d0 NAME cl+ssl FILENAME cl_plus_ssl DEPS
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
    VERSION cl+ssl-20210411-git SIBLINGS (cl+ssl.test) PARASITES NIL) */
