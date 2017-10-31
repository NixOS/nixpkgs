args @ { fetchurl, ... }:
rec {
  baseName = ''caveman'';
  version = ''20170630-git'';

  description = ''Web Application Framework for Common Lisp'';

  deps = [ args."anaphora" args."cl-emb" args."cl-ppcre" args."cl-project" args."cl-syntax" args."cl-syntax-annot" args."clack-v1-compat" args."do-urlencode" args."local-time" args."myway" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/caveman/2017-06-30/caveman-20170630-git.tgz'';
    sha256 = ''0wpjnskcvrgvqn9gbr43yqnpcxfmdggbiyaxz9rrhgcis2rwjkj2'';
  };

  packageName = "caveman";

  asdFilesToKeep = ["caveman.asd"];
  overrides = x: x;
}
/* (SYSTEM caveman DESCRIPTION Web Application Framework for Common Lisp SHA256
    0wpjnskcvrgvqn9gbr43yqnpcxfmdggbiyaxz9rrhgcis2rwjkj2 URL
    http://beta.quicklisp.org/archive/caveman/2017-06-30/caveman-20170630-git.tgz
    MD5 774f85fa78792bde012bad78efff4b53 NAME caveman FILENAME caveman DEPS
    ((NAME anaphora FILENAME anaphora) (NAME cl-emb FILENAME cl-emb)
     (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-project FILENAME cl-project)
     (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-syntax-annot FILENAME cl-syntax-annot)
     (NAME clack-v1-compat FILENAME clack-v1-compat)
     (NAME do-urlencode FILENAME do-urlencode)
     (NAME local-time FILENAME local-time) (NAME myway FILENAME myway))
    DEPENDENCIES
    (anaphora cl-emb cl-ppcre cl-project cl-syntax cl-syntax-annot
     clack-v1-compat do-urlencode local-time myway)
    VERSION 20170630-git SIBLINGS
    (caveman-middleware-dbimanager caveman-test caveman2-db caveman2-test
     caveman2)
    PARASITES NIL) */
