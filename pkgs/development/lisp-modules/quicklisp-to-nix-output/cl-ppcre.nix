args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre'';
  version = ''20180831-git'';

  parasites = [ "cl-ppcre-test" ];

  description = ''Perl-compatible regular expression library'';

  deps = [ args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ppcre/2018-08-31/cl-ppcre-20180831-git.tgz'';
    sha256 = ''03x6hg2wzjwx9znqpzs9mmbrz81380ac6jkyblnsafbzr3d0rgyb'';
  };

  packageName = "cl-ppcre";

  asdFilesToKeep = ["cl-ppcre.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ppcre DESCRIPTION Perl-compatible regular expression library
    SHA256 03x6hg2wzjwx9znqpzs9mmbrz81380ac6jkyblnsafbzr3d0rgyb URL
    http://beta.quicklisp.org/archive/cl-ppcre/2018-08-31/cl-ppcre-20180831-git.tgz
    MD5 021ef17563de8e5d5f5942629972785d NAME cl-ppcre FILENAME cl-ppcre DEPS
    ((NAME flexi-streams FILENAME flexi-streams)) DEPENDENCIES (flexi-streams)
    VERSION 20180831-git SIBLINGS (cl-ppcre-unicode) PARASITES (cl-ppcre-test)) */
