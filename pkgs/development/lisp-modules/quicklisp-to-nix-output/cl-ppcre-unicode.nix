args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre-unicode'';
  version = ''cl-ppcre-2.0.11'';

  parasites = [ "cl-ppcre-unicode-test" ];

  description = ''Perl-compatible regular expression library (Unicode)'';

  deps = [ args."cl-ppcre" args."cl-ppcre-test" args."cl-unicode" args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ppcre/2015-09-23/cl-ppcre-2.0.11.tgz'';
    sha256 = ''1djciws9n0jg3qdrck3j4wj607zvkbir8p379mp0p7b5g0glwvb2'';
  };

  packageName = "cl-ppcre-unicode";

  asdFilesToKeep = ["cl-ppcre-unicode.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ppcre-unicode DESCRIPTION
    Perl-compatible regular expression library (Unicode) SHA256
    1djciws9n0jg3qdrck3j4wj607zvkbir8p379mp0p7b5g0glwvb2 URL
    http://beta.quicklisp.org/archive/cl-ppcre/2015-09-23/cl-ppcre-2.0.11.tgz
    MD5 6d5250467c05eb661a76d395186a1da0 NAME cl-ppcre-unicode FILENAME
    cl-ppcre-unicode DEPS
    ((NAME cl-ppcre FILENAME cl-ppcre)
     (NAME cl-ppcre-test FILENAME cl-ppcre-test)
     (NAME cl-unicode FILENAME cl-unicode)
     (NAME flexi-streams FILENAME flexi-streams))
    DEPENDENCIES (cl-ppcre cl-ppcre-test cl-unicode flexi-streams) VERSION
    cl-ppcre-2.0.11 SIBLINGS (cl-ppcre) PARASITES (cl-ppcre-unicode-test)) */
