args @ { fetchurl, ... }:
rec {
  baseName = ''cl-test-more'';
  version = ''prove-20170403-git'';

  description = '''';

  deps = [ args."alexandria" args."anaphora" args."cl-ansi-text" args."cl-colors" args."cl-ppcre" args."let-plus" args."prove" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/prove/2017-04-03/prove-20170403-git.tgz'';
    sha256 = ''091xxkn9zj22c4gmm8x714k29bs4j0j7akppwh55zjsmrxdhqcpl'';
  };

  packageName = "cl-test-more";

  asdFilesToKeep = ["cl-test-more.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-test-more DESCRIPTION NIL SHA256
    091xxkn9zj22c4gmm8x714k29bs4j0j7akppwh55zjsmrxdhqcpl URL
    http://beta.quicklisp.org/archive/prove/2017-04-03/prove-20170403-git.tgz
    MD5 063b615692c8711d2392204ecf1b37b7 NAME cl-test-more FILENAME
    cl-test-more DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME cl-ansi-text FILENAME cl-ansi-text)
     (NAME cl-colors FILENAME cl-colors) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME let-plus FILENAME let-plus) (NAME prove FILENAME prove))
    DEPENDENCIES
    (alexandria anaphora cl-ansi-text cl-colors cl-ppcre let-plus prove)
    VERSION prove-20170403-git SIBLINGS (prove-asdf prove-test prove) PARASITES
    NIL) */
