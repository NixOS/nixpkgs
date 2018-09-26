args @ { fetchurl, ... }:
rec {
  baseName = ''fast-http'';
  version = ''20180831-git'';

  description = ''A fast HTTP protocol parser in Common Lisp'';

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."flexi-streams" args."proc-parse" args."smart-buffer" args."trivial-features" args."trivial-gray-streams" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-http/2018-08-31/fast-http-20180831-git.tgz'';
    sha256 = ''1827ra8nkjh5ghg2hn96w3zs8n1lvqzbf8wmzrcs8yky3l0m4qrm'';
  };

  packageName = "fast-http";

  asdFilesToKeep = ["fast-http.asd"];
  overrides = x: x;
}
/* (SYSTEM fast-http DESCRIPTION A fast HTTP protocol parser in Common Lisp
    SHA256 1827ra8nkjh5ghg2hn96w3zs8n1lvqzbf8wmzrcs8yky3l0m4qrm URL
    http://beta.quicklisp.org/archive/fast-http/2018-08-31/fast-http-20180831-git.tgz
    MD5 d5e839f204b2dd78a390336572d1ee65 NAME fast-http FILENAME fast-http DEPS
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
    VERSION 20180831-git SIBLINGS (fast-http-test) PARASITES NIL) */
