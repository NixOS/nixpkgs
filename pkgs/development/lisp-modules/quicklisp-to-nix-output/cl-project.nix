args @ { fetchurl, ... }:
{
  baseName = ''cl-project'';
  version = ''20190521-git'';

  description = ''Generate a skeleton for modern project'';

  deps = [ args."alexandria" args."anaphora" args."bordeaux-threads" args."cl-ansi-text" args."cl-colors" args."cl-emb" args."cl-fad" args."cl-ppcre" args."let-plus" args."local-time" args."prove" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-project/2019-05-21/cl-project-20190521-git.tgz'';
    sha256 = ''1wm1php6bdyy1gy76vfxlmh1lm7snqg1mhpzhkcmqrrmz0jx0gnf'';
  };

  packageName = "cl-project";

  asdFilesToKeep = ["cl-project.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-project DESCRIPTION Generate a skeleton for modern project SHA256
    1wm1php6bdyy1gy76vfxlmh1lm7snqg1mhpzhkcmqrrmz0jx0gnf URL
    http://beta.quicklisp.org/archive/cl-project/2019-05-21/cl-project-20190521-git.tgz
    MD5 1468189ff8880f43034c44adc317274f NAME cl-project FILENAME cl-project
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-colors FILENAME cl-colors) (NAME cl-emb FILENAME cl-emb)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME let-plus FILENAME let-plus) (NAME local-time FILENAME local-time)
     (NAME prove FILENAME prove) (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria anaphora bordeaux-threads cl-ansi-text cl-colors cl-emb cl-fad
     cl-ppcre let-plus local-time prove uiop)
    VERSION 20190521-git SIBLINGS (cl-project-test) PARASITES NIL) */
