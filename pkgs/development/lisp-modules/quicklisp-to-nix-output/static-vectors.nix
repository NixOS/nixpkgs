/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "static-vectors";
  version = "v1.8.6";

  parasites = [ "static-vectors/test" ];

  description = "Create vectors allocated in static memory.";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."fiveam" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/static-vectors/2020-06-10/static-vectors-v1.8.6.tgz";
    sha256 = "0s549cxd8a8ix6jl4dfxj2nh01nl9f4hgnlmb88w7iixanxn58mc";
  };

  packageName = "static-vectors";

  asdFilesToKeep = ["static-vectors.asd"];
  overrides = x: x;
}
/* (SYSTEM static-vectors DESCRIPTION
    Create vectors allocated in static memory. SHA256
    0s549cxd8a8ix6jl4dfxj2nh01nl9f4hgnlmb88w7iixanxn58mc URL
    http://beta.quicklisp.org/archive/static-vectors/2020-06-10/static-vectors-v1.8.6.tgz
    MD5 c817377fc6807d9c7bee6bd8996068b5 NAME static-vectors FILENAME
    static-vectors DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME fiveam FILENAME fiveam)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain fiveam trivial-features)
    VERSION v1.8.6 SIBLINGS NIL PARASITES (static-vectors/test)) */
