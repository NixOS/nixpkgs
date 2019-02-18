args @ { fetchurl, ... }:
rec {
  baseName = ''myway'';
  version = ''20181018-git'';

  description = ''Sinatra-compatible routing library.'';

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."cl-utilities" args."map-set" args."quri" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/myway/2018-10-18/myway-20181018-git.tgz'';
    sha256 = ''0ffd92mmir2k6i4771ppqvb3xhqlk2yh5znx7i391vq5ji3k5jij'';
  };

  packageName = "myway";

  asdFilesToKeep = ["myway.asd"];
  overrides = x: x;
}
/* (SYSTEM myway DESCRIPTION Sinatra-compatible routing library. SHA256
    0ffd92mmir2k6i4771ppqvb3xhqlk2yh5znx7i391vq5ji3k5jij URL
    http://beta.quicklisp.org/archive/myway/2018-10-18/myway-20181018-git.tgz
    MD5 88adecdaec89ceb262559d443512e545 NAME myway FILENAME myway DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-utilities FILENAME cl-utilities) (NAME map-set FILENAME map-set)
     (NAME quri FILENAME quri) (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-ppcre cl-utilities map-set quri split-sequence
     trivial-features)
    VERSION 20181018-git SIBLINGS (myway-test) PARASITES NIL) */
