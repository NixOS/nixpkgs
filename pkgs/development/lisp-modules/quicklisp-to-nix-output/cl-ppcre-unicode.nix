args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre-unicode'';
  version = ''cl-ppcre-20180831-git'';

  parasites = [ "cl-ppcre-unicode-test" ];

  description = ''Perl-compatible regular expression library (Unicode)'';

  deps = [ args."cl-ppcre" args."cl-ppcre-test" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ppcre/2018-08-31/cl-ppcre-20180831-git.tgz'';
    sha256 = ''03x6hg2wzjwx9znqpzs9mmbrz81380ac6jkyblnsafbzr3d0rgyb'';
  };

  packageName = "cl-ppcre-unicode";

  asdFilesToKeep = ["cl-ppcre-unicode.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ppcre-unicode DESCRIPTION
    Perl-compatible regular expression library (Unicode) SHA256
    03x6hg2wzjwx9znqpzs9mmbrz81380ac6jkyblnsafbzr3d0rgyb URL
    http://beta.quicklisp.org/archive/cl-ppcre/2018-08-31/cl-ppcre-20180831-git.tgz
    MD5 021ef17563de8e5d5f5942629972785d NAME cl-ppcre-unicode FILENAME
    cl-ppcre-unicode DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-test FILENAME cl-ppcre-test)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre cl-ppcre-test cl-unicode flexi-streams) VERSION
    cl-ppcre-20180831-git SIBLINGS (cl-ppcre) PARASITES (cl-ppcre-unicode-test)) */
