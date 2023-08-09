/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "myway";
  version = "20200325-git";

  description = "Sinatra-compatible routing library.";

  deps = [ args."alexandria" args."babel" args."cl-ppcre" args."cl-utilities" args."map-set" args."quri" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/myway/2020-03-25/myway-20200325-git.tgz";
    sha256 = "07r0mq9n0gmm7n20mkpsnmjvcr4gj9nckpnh1c2mddrb3sag8n15";
  };

  packageName = "myway";

  asdFilesToKeep = ["myway.asd"];
  overrides = x: x;
}
/* (SYSTEM myway DESCRIPTION Sinatra-compatible routing library. SHA256
    07r0mq9n0gmm7n20mkpsnmjvcr4gj9nckpnh1c2mddrb3sag8n15 URL
    http://beta.quicklisp.org/archive/myway/2020-03-25/myway-20200325-git.tgz
    MD5 af1fe34c2106303504c7908b25c3b9ce NAME myway FILENAME myway DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-utilities FILENAME cl-utilities) (NAME map-set FILENAME map-set)
     (NAME quri FILENAME quri) (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel cl-ppcre cl-utilities map-set quri split-sequence
     trivial-features)
    VERSION 20200325-git SIBLINGS (myway-test) PARASITES NIL) */
