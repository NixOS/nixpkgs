/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-ppcre-unicode";
  version = "cl-ppcre-20190521-git";

  parasites = [ "cl-ppcre-unicode-test" ];

  description = "Perl-compatible regular expression library (Unicode)";

  deps = [ args."cl-ppcre" args."cl-ppcre-test" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-ppcre/2019-05-21/cl-ppcre-20190521-git.tgz";
    sha256 = "0p6jcvf9afnsg80a1zqsp7fyz0lf1fxzbin7rs9bl4i6jvm0hjqx";
  };

  packageName = "cl-ppcre-unicode";

  asdFilesToKeep = ["cl-ppcre-unicode.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ppcre-unicode DESCRIPTION
    Perl-compatible regular expression library (Unicode) SHA256
    0p6jcvf9afnsg80a1zqsp7fyz0lf1fxzbin7rs9bl4i6jvm0hjqx URL
    http://beta.quicklisp.org/archive/cl-ppcre/2019-05-21/cl-ppcre-20190521-git.tgz
    MD5 a980b75c1b386b49bcb28107991eb4ec NAME cl-ppcre-unicode FILENAME
    cl-ppcre-unicode DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-test FILENAME cl-ppcre-test)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre cl-ppcre-test cl-unicode flexi-streams) VERSION
    cl-ppcre-20190521-git SIBLINGS (cl-ppcre) PARASITES (cl-ppcre-unicode-test)) */
