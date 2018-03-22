args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre'';
  version = ''20171227-git'';

  parasites = [ "cl-ppcre-test" ];

  description = ''Perl-compatible regular expression library'';

  deps = [ args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ppcre/2017-12-27/cl-ppcre-20171227-git.tgz'';
    sha256 = ''0vdic9kxjslplafh6d00m7mab38hw09ps2sxxbg3adciwvspvmw4'';
  };

  packageName = "cl-ppcre";

  asdFilesToKeep = ["cl-ppcre.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ppcre DESCRIPTION Perl-compatible regular expression library
    SHA256 0vdic9kxjslplafh6d00m7mab38hw09ps2sxxbg3adciwvspvmw4 URL
    http://beta.quicklisp.org/archive/cl-ppcre/2017-12-27/cl-ppcre-20171227-git.tgz
    MD5 9d8ce62ef1a71a5e1e144a31be698d8c NAME cl-ppcre FILENAME cl-ppcre DEPS
    ((NAME flexi-streams FILENAME flexi-streams)) DEPENDENCIES (flexi-streams)
    VERSION 20171227-git SIBLINGS (cl-ppcre-unicode) PARASITES (cl-ppcre-test)) */
