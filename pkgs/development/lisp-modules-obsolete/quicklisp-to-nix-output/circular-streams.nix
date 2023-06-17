/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "circular-streams";
  version = "20161204-git";

  description = "Circularly readable streams for Common Lisp";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."fast-io" args."static-vectors" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/circular-streams/2016-12-04/circular-streams-20161204-git.tgz";
    sha256 = "1i29b9sciqs5x59hlkdj2r4siyqgrwj5hb4lnc80jgfqvzbq4128";
  };

  packageName = "circular-streams";

  asdFilesToKeep = ["circular-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM circular-streams DESCRIPTION
    Circularly readable streams for Common Lisp SHA256
    1i29b9sciqs5x59hlkdj2r4siyqgrwj5hb4lnc80jgfqvzbq4128 URL
    http://beta.quicklisp.org/archive/circular-streams/2016-12-04/circular-streams-20161204-git.tgz
    MD5 2383f3b82fa3335d9106e1354a678db8 NAME circular-streams FILENAME
    circular-streams DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME fast-io FILENAME fast-io)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain fast-io static-vectors
     trivial-features trivial-gray-streams)
    VERSION 20161204-git SIBLINGS (circular-streams-test) PARASITES NIL) */
