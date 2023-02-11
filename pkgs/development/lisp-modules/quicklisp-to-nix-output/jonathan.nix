/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "jonathan";
  version = "20200925-git";

  description = "High performance JSON encoder and decoder. Currently support: SBCL, CCL.";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-annot" args."cl-ppcre" args."cl-syntax" args."cl-syntax-annot" args."fast-io" args."named-readtables" args."proc-parse" args."static-vectors" args."trivial-features" args."trivial-gray-streams" args."trivial-types" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/jonathan/2020-09-25/jonathan-20200925-git.tgz";
    sha256 = "1y5v3g351nsy7px0frdr2asmcy0lyfbj73ic1f5yf4q65hrgvryx";
  };

  packageName = "jonathan";

  asdFilesToKeep = ["jonathan.asd"];
  overrides = x: x;
}
/* (SYSTEM jonathan DESCRIPTION
    High performance JSON encoder and decoder. Currently support: SBCL, CCL.
    SHA256 1y5v3g351nsy7px0frdr2asmcy0lyfbj73ic1f5yf4q65hrgvryx URL
    http://beta.quicklisp.org/archive/jonathan/2020-09-25/jonathan-20200925-git.tgz
    MD5 27cad3c107544f587f9f33295c10d81e NAME jonathan FILENAME jonathan DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME cl-annot FILENAME cl-annot) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME fast-io FILENAME fast-io)
     (NAME named-readtables FILENAME named-readtables)
     (NAME proc-parse FILENAME proc-parse)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-types FILENAME trivial-types))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain cl-annot cl-ppcre
     cl-syntax cl-syntax-annot fast-io named-readtables proc-parse
     static-vectors trivial-features trivial-gray-streams trivial-types)
    VERSION 20200925-git SIBLINGS (jonathan-test) PARASITES NIL) */
