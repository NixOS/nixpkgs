args @ { fetchurl, ... }:
{
  baseName = ''cl-cookie'';
  version = ''20150804-git'';

  description = ''HTTP cookie manager'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cl-fad" args."cl-ppcre" args."cl-utilities" args."local-time" args."proc-parse" args."quri" args."split-sequence" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-cookie/2015-08-04/cl-cookie-20150804-git.tgz'';
    sha256 = ''0llh5d2p7wi5amzpckng1bzmf2bdfdwkfapcdq0znqlzd5bvbby8'';
  };

  packageName = "cl-cookie";

  asdFilesToKeep = ["cl-cookie.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-cookie DESCRIPTION HTTP cookie manager SHA256
    0llh5d2p7wi5amzpckng1bzmf2bdfdwkfapcdq0znqlzd5bvbby8 URL
    http://beta.quicklisp.org/archive/cl-cookie/2015-08-04/cl-cookie-20150804-git.tgz
    MD5 d2c08a71afd47b3ad42e1234ec1a3083 NAME cl-cookie FILENAME cl-cookie DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-fad FILENAME cl-fad) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-utilities FILENAME cl-utilities)
     (NAME local-time FILENAME local-time)
     (NAME proc-parse FILENAME proc-parse) (NAME quri FILENAME quri)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES
    (alexandria babel bordeaux-threads cl-fad cl-ppcre cl-utilities local-time
     proc-parse quri split-sequence trivial-features)
    VERSION 20150804-git SIBLINGS (cl-cookie-test) PARASITES NIL) */
