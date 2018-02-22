args @ { fetchurl, ... }:
rec {
  baseName = ''cl-project'';
  version = ''20171019-git'';

  description = ''Generate a skeleton for modern project'';

  deps = [ args."alexandria" args."anaphora" args."bordeaux-threads" args."cl-ansi-text" args."cl-colors" args."cl-emb" args."cl-fad" args."cl-ppcre" args."let-plus" args."local-time" args."prove" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-project/2017-10-19/cl-project-20171019-git.tgz'';
    sha256 = ''1phgpik46dvqxnd49kccy4fh653659qd86hv7km50m07nzm8fn7q'';
  };

  packageName = "cl-project";

  asdFilesToKeep = ["cl-project.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-project DESCRIPTION Generate a skeleton for modern project SHA256
    1phgpik46dvqxnd49kccy4fh653659qd86hv7km50m07nzm8fn7q URL
    http://beta.quicklisp.org/archive/cl-project/2017-10-19/cl-project-20171019-git.tgz
    MD5 9dbfd7f9b0a83ca608031ebf32185a0f NAME cl-project FILENAME cl-project
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
    VERSION 20171019-git SIBLINGS (cl-project-test) PARASITES NIL) */
