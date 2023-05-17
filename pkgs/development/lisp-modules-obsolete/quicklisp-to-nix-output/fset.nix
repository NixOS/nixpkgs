/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "fset";
  version = "20200925-git";

  parasites = [ "fset/test" ];

  description = "A functional set-theoretic collections library.
See: http://www.ergy.com/FSet.html
";

  deps = [ args."misc-extensions" args."mt19937" args."named-readtables" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/fset/2020-09-25/fset-20200925-git.tgz";
    sha256 = "19fr6ds1a493b0kbsligpn7i771r1yfshbbkdp0hxs4l792l05wv";
  };

  packageName = "fset";

  asdFilesToKeep = ["fset.asd"];
  overrides = x: x;
}
/* (SYSTEM fset DESCRIPTION A functional set-theoretic collections library.
See: http://www.ergy.com/FSet.html

    SHA256 19fr6ds1a493b0kbsligpn7i771r1yfshbbkdp0hxs4l792l05wv URL
    http://beta.quicklisp.org/archive/fset/2020-09-25/fset-20200925-git.tgz MD5
    481e7207099c061459db68813e7bf70c NAME fset FILENAME fset DEPS
    ((NAME misc-extensions FILENAME misc-extensions)
     (NAME mt19937 FILENAME mt19937)
     (NAME named-readtables FILENAME named-readtables))
    DEPENDENCIES (misc-extensions mt19937 named-readtables) VERSION
    20200925-git SIBLINGS NIL PARASITES (fset/test)) */
