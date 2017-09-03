args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre'';
  version = ''2.0.11'';

  parasites = [ "cl-ppcre-test" ];

  description = ''Perl-compatible regular expression library'';

  deps = [ args."flexi-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ppcre/2015-09-23/cl-ppcre-2.0.11.tgz'';
    sha256 = ''1djciws9n0jg3qdrck3j4wj607zvkbir8p379mp0p7b5g0glwvb2'';
  };

  packageName = "cl-ppcre";

  asdFilesToKeep = ["cl-ppcre.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ppcre DESCRIPTION Perl-compatible regular expression library
    SHA256 1djciws9n0jg3qdrck3j4wj607zvkbir8p379mp0p7b5g0glwvb2 URL
    http://beta.quicklisp.org/archive/cl-ppcre/2015-09-23/cl-ppcre-2.0.11.tgz
    MD5 6d5250467c05eb661a76d395186a1da0 NAME cl-ppcre FILENAME cl-ppcre DEPS
    ((NAME flexi-streams FILENAME flexi-streams)) DEPENDENCIES (flexi-streams)
    VERSION 2.0.11 SIBLINGS (cl-ppcre-unicode) PARASITES (cl-ppcre-test)) */
