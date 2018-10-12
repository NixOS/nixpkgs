args @ { fetchurl, ... }:
rec {
  baseName = ''cl-project'';
  version = ''20180831-git'';

  description = ''Generate a skeleton for modern project'';

  deps = [ args."alexandria" args."anaphora" args."bordeaux-threads" args."cl-ansi-text" args."cl-colors" args."cl-emb" args."cl-fad" args."cl-ppcre" args."let-plus" args."local-time" args."prove" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-project/2018-08-31/cl-project-20180831-git.tgz'';
    sha256 = ''0iifc03sj982bjakvy0k3m6zsidc3k1ds6xaq36wzgzgw7x6lm0s'';
  };

  packageName = "cl-project";

  asdFilesToKeep = ["cl-project.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-project DESCRIPTION Generate a skeleton for modern project SHA256
    0iifc03sj982bjakvy0k3m6zsidc3k1ds6xaq36wzgzgw7x6lm0s URL
    http://beta.quicklisp.org/archive/cl-project/2018-08-31/cl-project-20180831-git.tgz
    MD5 11fbcc0f4f5c6d7b921eb83ab5f3ee1b NAME cl-project FILENAME cl-project
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
    VERSION 20180831-git SIBLINGS (cl-project-test) PARASITES NIL) */
