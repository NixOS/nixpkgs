/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-ppcre";
  version = "20190521-git";

  parasites = [ "cl-ppcre-test" ];

  description = "Perl-compatible regular expression library";

  deps = [ args."flexi-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-ppcre/2019-05-21/cl-ppcre-20190521-git.tgz";
    sha256 = "0p6jcvf9afnsg80a1zqsp7fyz0lf1fxzbin7rs9bl4i6jvm0hjqx";
  };

  packageName = "cl-ppcre";

  asdFilesToKeep = ["cl-ppcre.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ppcre DESCRIPTION Perl-compatible regular expression library
    SHA256 0p6jcvf9afnsg80a1zqsp7fyz0lf1fxzbin7rs9bl4i6jvm0hjqx URL
    http://beta.quicklisp.org/archive/cl-ppcre/2019-05-21/cl-ppcre-20190521-git.tgz
    MD5 a980b75c1b386b49bcb28107991eb4ec NAME cl-ppcre FILENAME cl-ppcre DEPS
    ((NAME flexi-streams FILENAME flexi-streams)) DEPENDENCIES (flexi-streams)
    VERSION 20190521-git SIBLINGS (cl-ppcre-unicode) PARASITES (cl-ppcre-test)) */
