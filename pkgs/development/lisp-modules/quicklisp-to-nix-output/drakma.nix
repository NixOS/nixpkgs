args @ { fetchurl, ... }:
rec {
  baseName = ''drakma'';
  version = ''v2.0.3'';

  description = ''Full-featured http/https client based on usocket'';

  deps = [ args."chipz" args."chunga" args."cl+ssl" args."cl-base64" args."cl-ppcre" args."flexi-streams" args."puri" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/drakma/2017-06-30/drakma-v2.0.3.tgz'';
    sha256 = ''1xbbwd2gg17pq03bblj6imh7lq39z2w3yix6fm25509gyhs76ymd'';
  };

  packageName = "drakma";

  asdFilesToKeep = ["drakma.asd"];
  overrides = x: x;
}
/* (SYSTEM drakma DESCRIPTION Full-featured http/https client based on usocket
    SHA256 1xbbwd2gg17pq03bblj6imh7lq39z2w3yix6fm25509gyhs76ymd URL
    http://beta.quicklisp.org/archive/drakma/2017-06-30/drakma-v2.0.3.tgz MD5
    3578c67b445cf982414ff78b2fb8d295 NAME drakma FILENAME drakma DEPS
    ((NAME chipz FILENAME chipz) (NAME chunga FILENAME chunga)
     (NAME cl+ssl FILENAME cl+ssl) (NAME cl-base64 FILENAME cl-base64)
     (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME flexi-streams FILENAME flexi-streams) (NAME puri FILENAME puri)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (chipz chunga cl+ssl cl-base64 cl-ppcre flexi-streams puri usocket) VERSION
    v2.0.3 SIBLINGS (drakma-test) PARASITES NIL) */
