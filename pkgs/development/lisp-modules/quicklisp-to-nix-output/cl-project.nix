/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-project";
  version = "20200715-git";

  description = "Generate a skeleton for modern project";

  deps = [ args."alexandria" args."anaphora" args."cl-ansi-text" args."cl-colors" args."cl-colors2" args."cl-emb" args."cl-ppcre" args."let-plus" args."local-time" args."prove" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-project/2020-07-15/cl-project-20200715-git.tgz";
    sha256 = "044rx97wc839a8q2wv271s07bnsasl6x5fx4gr5pvy34jbrhp306";
  };

  packageName = "cl-project";

  asdFilesToKeep = ["cl-project.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-project DESCRIPTION Generate a skeleton for modern project SHA256
    044rx97wc839a8q2wv271s07bnsasl6x5fx4gr5pvy34jbrhp306 URL
    http://beta.quicklisp.org/archive/cl-project/2020-07-15/cl-project-20200715-git.tgz
    MD5 12b436050ad0106cf292707ae39d8572 NAME cl-project FILENAME cl-project
    DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-colors FILENAME cl-colors) (NAME cl-colors2 FILENAME cl-colors2)
     (NAME cl-emb FILENAME cl-emb) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME let-plus FILENAME let-plus) (NAME local-time FILENAME local-time)
     (NAME prove FILENAME prove) (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria anaphora cl-ansi-text cl-colors cl-colors2 cl-emb cl-ppcre
     let-plus local-time prove uiop)
    VERSION 20200715-git SIBLINGS (cl-project-test) PARASITES NIL) */
