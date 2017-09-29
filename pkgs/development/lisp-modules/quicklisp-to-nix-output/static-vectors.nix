args @ { fetchurl, ... }:
rec {
  baseName = ''static-vectors'';
  version = ''v1.8.2'';

  parasites = [ "static-vectors/test" ];

  description = ''Create vectors allocated in static memory.'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."fiveam" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/static-vectors/2017-01-24/static-vectors-v1.8.2.tgz'';
    sha256 = ''0p35f0wrnv46bmmxlviwpsbxnlnkmxwd3xp858lhf0dy52cyra1g'';
  };

  packageName = "static-vectors";

  asdFilesToKeep = ["static-vectors.asd"];
  overrides = x: x;
}
/* (SYSTEM static-vectors DESCRIPTION
    Create vectors allocated in static memory. SHA256
    0p35f0wrnv46bmmxlviwpsbxnlnkmxwd3xp858lhf0dy52cyra1g URL
    http://beta.quicklisp.org/archive/static-vectors/2017-01-24/static-vectors-v1.8.2.tgz
    MD5 fd3ebe4e79a71c49e32ac87d6a1bcaf4 NAME static-vectors FILENAME
    static-vectors DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME fiveam FILENAME fiveam)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi cffi-grovel fiveam trivial-features)
    VERSION v1.8.2 SIBLINGS NIL PARASITES (static-vectors/test)) */
