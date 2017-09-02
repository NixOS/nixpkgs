args @ { fetchurl, ... }:
rec {
  baseName = ''lquery'';
  version = ''20170630-git'';

  description = ''A library to allow jQuery-like HTML/DOM manipulation.'';

  deps = [ args."array-utils" args."clss" args."form-fiddle" args."plump" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lquery/2017-06-30/lquery-20170630-git.tgz'';
    sha256 = ''19lpzjidg31lw61b78vdsqzrsdw2js4a9s7zzr5049jpzbspszjm'';
  };

  packageName = "lquery";

  asdFilesToKeep = ["lquery.asd"];
  overrides = x: x;
}
/* (SYSTEM lquery DESCRIPTION
    A library to allow jQuery-like HTML/DOM manipulation. SHA256
    19lpzjidg31lw61b78vdsqzrsdw2js4a9s7zzr5049jpzbspszjm URL
    http://beta.quicklisp.org/archive/lquery/2017-06-30/lquery-20170630-git.tgz
    MD5 aeb03cb5174d682092683da488531a9c NAME lquery FILENAME lquery DEPS
    ((NAME array-utils FILENAME array-utils) (NAME clss FILENAME clss)
     (NAME form-fiddle FILENAME form-fiddle) (NAME plump FILENAME plump))
    DEPENDENCIES (array-utils clss form-fiddle plump) VERSION 20170630-git
    SIBLINGS (lquery-test) PARASITES NIL) */
