args @ { fetchurl, ... }:
rec {
  baseName = ''cl-change-case'';
  version = ''20191007-git'';

  description = ''Convert strings between camelCase, param-case, PascalCase and more'';

  deps = [ args."cl-ppcre" args."cl-ppcre-unicode" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-change-case/2019-10-07/cl-change-case-20191007-git.tgz'';
    sha256 = ''097n7bzlsryqh6gbwn3nzi9qdw4jhck4vn3qw41zpc496xfgz9y1'';
  };

  packageName = "cl-change-case";

  asdFilesToKeep = ["cl-change-case.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-change-case DESCRIPTION
    Convert strings between camelCase, param-case, PascalCase and more SHA256
    097n7bzlsryqh6gbwn3nzi9qdw4jhck4vn3qw41zpc496xfgz9y1 URL
    http://beta.quicklisp.org/archive/cl-change-case/2019-10-07/cl-change-case-20191007-git.tgz
    MD5 385245df04b1f1514b9fd709a08c4082 NAME cl-change-case FILENAME
    cl-change-case DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-unicode FILENAME cl-ppcre-unicode)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre cl-ppcre-unicode cl-unicode flexi-streams) VERSION
    20191007-git SIBLINGS (cl-change-case-test) PARASITES NIL) */
