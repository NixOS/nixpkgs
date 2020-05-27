args @ { fetchurl, ... }:
rec {
  baseName = ''static-vectors'';
  version = ''v1.8.4'';

  parasites = [ "static-vectors/test" ];

  description = ''Create vectors allocated in static memory.'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."fiveam" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/static-vectors/2019-11-30/static-vectors-v1.8.4.tgz'';
    sha256 = ''07z3nrsf5ds5iqilpi8awfk5flgy0k58znnn94xlx82hznw4hwxp'';
  };

  packageName = "static-vectors";

  asdFilesToKeep = ["static-vectors.asd"];
  overrides = x: x;
}
/* (SYSTEM static-vectors DESCRIPTION
    Create vectors allocated in static memory. SHA256
    07z3nrsf5ds5iqilpi8awfk5flgy0k58znnn94xlx82hznw4hwxp URL
    http://beta.quicklisp.org/archive/static-vectors/2019-11-30/static-vectors-v1.8.4.tgz
    MD5 401085c3ec0edc3ab47409e5a4b534c7 NAME static-vectors FILENAME
    static-vectors DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME fiveam FILENAME fiveam)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain fiveam trivial-features)
    VERSION v1.8.4 SIBLINGS NIL PARASITES (static-vectors/test)) */
