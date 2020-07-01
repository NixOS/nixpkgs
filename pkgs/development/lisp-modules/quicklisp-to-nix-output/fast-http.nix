args @ { fetchurl, ... }:
rec {
  baseName = ''fast-http'';
  version = ''20191007-git'';

  description = ''A fast HTTP protocol parser in Common Lisp'';

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."flexi-streams" args."proc-parse" args."smart-buffer" args."trivial-features" args."trivial-gray-streams" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-http/2019-10-07/fast-http-20191007-git.tgz'';
    sha256 = ''00qnl56cfss2blm4pp03dwv84bmkyd0kbarhahclxbn8f7pgwf32'';
  };

  packageName = "fast-http";

  asdFilesToKeep = ["fast-http.asd"];
  overrides = x: x;
}
/* (SYSTEM fast-http DESCRIPTION A fast HTTP protocol parser in Common Lisp
    SHA256 00qnl56cfss2blm4pp03dwv84bmkyd0kbarhahclxbn8f7pgwf32 URL
    http://beta.quicklisp.org/archive/fast-http/2019-10-07/fast-http-20191007-git.tgz
    MD5 fd43be4dd72fd9bda5a3ecce87104c97 NAME fast-http FILENAME fast-http DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME flexi-streams FILENAME flexi-streams)
     (NAME proc-parse FILENAME proc-parse)
     (NAME smart-buffer FILENAME smart-buffer)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES
    (alexandria babel cl-utilities flexi-streams proc-parse smart-buffer
     trivial-features trivial-gray-streams xsubseq)
    VERSION 20191007-git SIBLINGS (fast-http-test) PARASITES NIL) */
