args @ { fetchurl, ... }:
rec {
  baseName = ''lquery'';
  version = ''20160929-git'';

  description = ''A library to allow jQuery-like HTML/DOM manipulation.'';

  deps = [ args."array-utils" args."clss" args."form-fiddle" args."plump" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lquery/2016-09-29/lquery-20160929-git.tgz'';
    sha256 = ''1kqc0n4zh44yay9vbv6wirk3122q7if2999146lrgada5fy17r7x'';
  };

  overrides = x: {
  };
}
