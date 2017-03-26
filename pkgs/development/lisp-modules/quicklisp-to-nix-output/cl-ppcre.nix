args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ppcre'';
  version = ''2.0.11'';

  description = ''Perl-compatible regular expression library'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ppcre/2015-09-23/cl-ppcre-2.0.11.tgz'';
    sha256 = ''1djciws9n0jg3qdrck3j4wj607zvkbir8p379mp0p7b5g0glwvb2'';
  };
}
