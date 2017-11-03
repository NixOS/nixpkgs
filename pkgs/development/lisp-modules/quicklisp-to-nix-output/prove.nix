args @ { fetchurl, ... }:
rec {
  baseName = ''prove'';
  version = ''20170403-git'';

  description = '''';

  deps = [ args."alexandria" args."anaphora" args."cl-ansi-text" args."cl-colors" args."cl-ppcre" args."let-plus" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/prove/2017-04-03/prove-20170403-git.tgz'';
    sha256 = ''091xxkn9zj22c4gmm8x714k29bs4j0j7akppwh55zjsmrxdhqcpl'';
  };

  packageName = "prove";

  asdFilesToKeep = ["prove.asd"];
  overrides = x: x;
}
/* (SYSTEM prove DESCRIPTION NIL SHA256
    091xxkn9zj22c4gmm8x714k29bs4j0j7akppwh55zjsmrxdhqcpl URL
    http://beta.quicklisp.org/archive/prove/2017-04-03/prove-20170403-git.tgz
    MD5 063b615692c8711d2392204ecf1b37b7 NAME prove FILENAME prove DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-colors FILENAME cl-colors) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME let-plus FILENAME let-plus) (NAME uiop FILENAME uiop))
    DEPENDENCIES
    (alexandria anaphora cl-ansi-text cl-colors cl-ppcre let-plus uiop) VERSION
    20170403-git SIBLINGS (cl-test-more prove-asdf prove-test) PARASITES NIL) */
