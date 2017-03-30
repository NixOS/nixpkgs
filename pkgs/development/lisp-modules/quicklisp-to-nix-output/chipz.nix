args @ { fetchurl, ... }:
rec {
  baseName = ''chipz'';
  version = ''20160318-git'';

  description = ''A library for decompressing deflate, zlib, and gzip data'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/chipz/2016-03-18/chipz-20160318-git.tgz'';
    sha256 = ''1dpsg8kd43k075xihb0szcq1f7iq8ryg5r77x5wi6hy9jhpq8826'';
  };
}
