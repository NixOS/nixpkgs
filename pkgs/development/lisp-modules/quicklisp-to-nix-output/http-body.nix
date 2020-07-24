args @ { fetchurl, ... }:
rec {
  baseName = ''http-body'';
  version = ''20190813-git'';

  description = ''HTTP POST data parser for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-grovel" args."cffi-toolchain" args."cl-annot" args."cl-ppcre" args."cl-syntax" args."cl-syntax-annot" args."cl-utilities" args."fast-http" args."fast-io" args."flexi-streams" args."jonathan" args."named-readtables" args."proc-parse" args."quri" args."smart-buffer" args."split-sequence" args."static-vectors" args."trivial-features" args."trivial-gray-streams" args."trivial-types" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/http-body/2019-08-13/http-body-20190813-git.tgz'';
    sha256 = ''1mc4xinqnvjr7cdyaywdb5lv9k34pal7lhp6f9a660r1rbxybvy8'';
  };

  packageName = "http-body";

  asdFilesToKeep = ["http-body.asd"];
  overrides = x: x;
}
/* (SYSTEM http-body DESCRIPTION HTTP POST data parser for Common Lisp SHA256
    1mc4xinqnvjr7cdyaywdb5lv9k34pal7lhp6f9a660r1rbxybvy8 URL
    http://beta.quicklisp.org/archive/http-body/2019-08-13/http-body-20190813-git.tgz
    MD5 d46ac52643ae7dc148438f84a8107a79 NAME http-body FILENAME http-body DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-grovel FILENAME cffi-grovel)
     (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME cl-annot FILENAME cl-annot) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME fast-http FILENAME fast-http) (NAME fast-io FILENAME fast-io)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME jonathan FILENAME jonathan)
     (NAME named-readtables FILENAME named-readtables)
     (NAME proc-parse FILENAME proc-parse) (NAME quri FILENAME quri)
     (NAME smart-buffer FILENAME smart-buffer)
     (NAME split-sequence FILENAME split-sequence)
     (NAME static-vectors FILENAME static-vectors)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME trivial-types FILENAME trivial-types)
     (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES
    (alexandria babel cffi cffi-grovel cffi-toolchain cl-annot cl-ppcre
     cl-syntax cl-syntax-annot cl-utilities fast-http fast-io flexi-streams
     jonathan named-readtables proc-parse quri smart-buffer split-sequence
     static-vectors trivial-features trivial-gray-streams trivial-types
     xsubseq)
    VERSION 20190813-git SIBLINGS (http-body-test) PARASITES NIL) */
