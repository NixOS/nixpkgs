args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre-unicode'';
  version = ''cl-ppcre-20171227-git'';

  parasites = [ "cl-ppcre-unicode-test" ];

  description = ''Perl-compatible regular expression library (Unicode)'';

  deps = [ args."cl-ppcre" args."cl-ppcre-test" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ppcre/2017-12-27/cl-ppcre-20171227-git.tgz'';
    sha256 = ''0vdic9kxjslplafh6d00m7mab38hw09ps2sxxbg3adciwvspvmw4'';
  };

  packageName = "cl-ppcre-unicode";

  asdFilesToKeep = ["cl-ppcre-unicode.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ppcre-unicode DESCRIPTION
    Perl-compatible regular expression library (Unicode) SHA256
    0vdic9kxjslplafh6d00m7mab38hw09ps2sxxbg3adciwvspvmw4 URL
    http://beta.quicklisp.org/archive/cl-ppcre/2017-12-27/cl-ppcre-20171227-git.tgz
    MD5 9d8ce62ef1a71a5e1e144a31be698d8c NAME cl-ppcre-unicode FILENAME
    cl-ppcre-unicode DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-test FILENAME cl-ppcre-test)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre cl-ppcre-test cl-unicode flexi-streams) VERSION
    cl-ppcre-20171227-git SIBLINGS (cl-ppcre) PARASITES (cl-ppcre-unicode-test)) */
