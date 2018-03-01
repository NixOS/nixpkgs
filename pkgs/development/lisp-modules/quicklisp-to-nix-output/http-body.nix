args @ { fetchurl, ... }:
rec {
  baseName = ''http-body'';
  version = ''20161204-git'';

  description = ''HTTP POST data parser for Common Lisp'';

  deps = [ args."alexandria" args."babel" args."cl-annot" args."cl-ppcre" args."cl-syntax" args."cl-utilities" args."fast-http" args."fast-io" args."flexi-streams" args."jonathan" args."proc-parse" args."quri" args."smart-buffer" args."split-sequence" args."trivial-features" args."trivial-gray-streams" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/http-body/2016-12-04/http-body-20161204-git.tgz'';
    sha256 = ''1y50yipsbl4j99igmfi83pr7p56hb31dcplpy05fp5alkb5rv0gi'';
  };

  packageName = "http-body";

  asdFilesToKeep = ["http-body.asd"];
  overrides = x: x;
}
/* (SYSTEM http-body DESCRIPTION HTTP POST data parser for Common Lisp SHA256
    1y50yipsbl4j99igmfi83pr7p56hb31dcplpy05fp5alkb5rv0gi URL
    http://beta.quicklisp.org/archive/http-body/2016-12-04/http-body-20161204-git.tgz
    MD5 6eda50cf89aa3b6a8e9ccaf324734a0e NAME http-body FILENAME http-body DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-annot FILENAME cl-annot) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME fast-http FILENAME fast-http) (NAME fast-io FILENAME fast-io)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME jonathan FILENAME jonathan) (NAME proc-parse FILENAME proc-parse)
     (NAME quri FILENAME quri) (NAME smart-buffer FILENAME smart-buffer)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES
    (alexandria babel cl-annot cl-ppcre cl-syntax cl-utilities fast-http
     fast-io flexi-streams jonathan proc-parse quri smart-buffer split-sequence
     trivial-features trivial-gray-streams xsubseq)
    VERSION 20161204-git SIBLINGS (http-body-test) PARASITES NIL) */
