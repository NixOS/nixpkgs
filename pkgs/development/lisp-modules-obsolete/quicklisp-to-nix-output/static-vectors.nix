/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "static-vectors";
  version = "v1.8.9";

  parasites = [ "static-vectors/test" ];

  description = "Create vectors allocated in static memory.";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."fiveam" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/static-vectors/2021-06-30/static-vectors-v1.8.9.tgz";
    sha256 = "01n4iz6s4n57gmxscnj9aign60kh6gp7ak5waqz5zwhsdklgj0j4";
  };

  packageName = "static-vectors";

  asdFilesToKeep = ["static-vectors.asd"];
  overrides = x: x;
}
/* (SYSTEM static-vectors DESCRIPTION
    Create vectors allocated in static memory. SHA256
    01n4iz6s4n57gmxscnj9aign60kh6gp7ak5waqz5zwhsdklgj0j4 URL
    http://beta.quicklisp.org/archive/static-vectors/2021-06-30/static-vectors-v1.8.9.tgz
    MD5 f14b819c0d55e7fbd28e9b4a0bb3bfc9 NAME static-vectors FILENAME
    static-vectors DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME fiveam FILENAME fiveam)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain fiveam trivial-features)
    VERSION v1.8.9 SIBLINGS NIL PARASITES (static-vectors/test)) */
