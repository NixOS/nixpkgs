args @ { fetchurl, ... }:
rec {
  baseName = ''fast-http'';
  version = ''20170630-git'';

  description = ''A fast HTTP protocol parser in Common Lisp'';

  deps = [ args."alexandria" args."babel" args."cl-utilities" args."proc-parse" args."smart-buffer" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/fast-http/2017-06-30/fast-http-20170630-git.tgz'';
    sha256 = ''0fkqwbwqc9a783ynjbszimcrannpqq4ja6wcf8ybgizr4zvsgj29'';
  };

  packageName = "fast-http";

  asdFilesToKeep = ["fast-http.asd"];
  overrides = x: x;
}
/* (SYSTEM fast-http DESCRIPTION A fast HTTP protocol parser in Common Lisp
    SHA256 0fkqwbwqc9a783ynjbszimcrannpqq4ja6wcf8ybgizr4zvsgj29 URL
    http://beta.quicklisp.org/archive/fast-http/2017-06-30/fast-http-20170630-git.tgz
    MD5 d117d59c1f71965e0c32b19e6790cf9a NAME fast-http FILENAME fast-http DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME proc-parse FILENAME proc-parse)
     (NAME smart-buffer FILENAME smart-buffer) (NAME xsubseq FILENAME xsubseq))
    DEPENDENCIES
    (alexandria babel cl-utilities proc-parse smart-buffer xsubseq) VERSION
    20170630-git SIBLINGS (fast-http-test) PARASITES NIL) */
