args @ { fetchurl, ... }:
rec {
  baseName = ''cl-project'';
  version = ''20160531-git'';

  description = ''Generate a skeleton for modern project'';

  deps = [ args."alexandria" args."anaphora" args."bordeaux-threads" args."cl-ansi-text" args."cl-colors" args."cl-emb" args."cl-fad" args."cl-ppcre" args."let-plus" args."local-time" args."prove" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-project/2016-05-31/cl-project-20160531-git.tgz'';
    sha256 = ''1xwjgs5pzkdnd9i5lcic9z41d1c4yf7pvarrvawfxcicg6rrfw81'';
  };

  packageName = "cl-project";

  asdFilesToKeep = ["cl-project.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-project DESCRIPTION Generate a skeleton for modern project SHA256
    1xwjgs5pzkdnd9i5lcic9z41d1c4yf7pvarrvawfxcicg6rrfw81 URL
    http://beta.quicklisp.org/archive/cl-project/2016-05-31/cl-project-20160531-git.tgz
    MD5 63de5ce6f0f3e5f60094a86d32c2f1a9 NAME cl-project FILENAME cl-project
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
    VERSION 20160531-git SIBLINGS (cl-project-test) PARASITES NIL) */
