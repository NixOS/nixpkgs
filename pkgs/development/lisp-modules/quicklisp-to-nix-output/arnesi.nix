/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "arnesi";
  version = "20170403-git";

  parasites = [ "arnesi/cl-ppcre-extras" "arnesi/slime-extras" ];

  description = "A bag-of-tools utilities library used to aid in implementing the bese.it toolkit";

  deps = [ args."alexandria" args."cl-ppcre" args."closer-mop" args."collectors" args."iterate" args."swank" args."symbol-munger" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/arnesi/2017-04-03/arnesi-20170403-git.tgz";
    sha256 = "01kirjpgv5pgbcdxjrnw3ld4jw7wrqm3rgqnxwac4gxaphr2s6q4";
  };

  packageName = "arnesi";

  asdFilesToKeep = ["arnesi.asd"];
  overrides = x: x;
}
/* (SYSTEM arnesi DESCRIPTION
    A bag-of-tools utilities library used to aid in implementing the bese.it toolkit
    SHA256 01kirjpgv5pgbcdxjrnw3ld4jw7wrqm3rgqnxwac4gxaphr2s6q4 URL
    http://beta.quicklisp.org/archive/arnesi/2017-04-03/arnesi-20170403-git.tgz
    MD5 bbb34e1a646b2cc489766690c741d964 NAME arnesi FILENAME arnesi DEPS
    ((NAME alexandria FILENAME alexandria) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME closer-mop FILENAME closer-mop)
     (NAME collectors FILENAME collectors) (NAME iterate FILENAME iterate)
     (NAME swank FILENAME swank) (NAME symbol-munger FILENAME symbol-munger))
    DEPENDENCIES
    (alexandria cl-ppcre closer-mop collectors iterate swank symbol-munger)
    VERSION 20170403-git SIBLINGS NIL PARASITES
    (arnesi/cl-ppcre-extras arnesi/slime-extras)) */
