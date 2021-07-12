/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fast-io";
  version = "20200925-git";

  description = "Alternative I/O mechanism to a stream or vector";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."static-vectors" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fast-io/2020-09-25/fast-io-20200925-git.tgz";
    sha256 = "1rgyr6y20fp3jqnx5snpjf9lngzalip2a28l04ssypwagmhaa975";
  };

  packageName = "fast-io";

  asdFilesToKeep = ["fast-io.asd"];
  overrides = x: x;
}
/* (SYSTEM fast-io DESCRIPTION Alternative I/O mechanism to a stream or vector
    SHA256 1rgyr6y20fp3jqnx5snpjf9lngzalip2a28l04ssypwagmhaa975 URL
    http://beta.quicklisp.org/archive/fast-io/2020-09-25/fast-io-20200925-git.tgz
    MD5 aa948bd29b8733f08e79a60226243117 NAME fast-io FILENAME fast-io DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain static-vectors
     trivial-features trivial-gray-streams)
    VERSION 20200925-git SIBLINGS (fast-io-test) PARASITES NIL) */
