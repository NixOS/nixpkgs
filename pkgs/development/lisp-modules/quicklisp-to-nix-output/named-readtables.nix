args @ { fetchurl, ... }:
rec {
  baseName = ''named-readtables'';
  version = ''20170124-git'';

  description = ''Library that creates a namespace for named readtable
  akin to the namespace of packages.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/named-readtables/2017-01-24/named-readtables-20170124-git.tgz'';
    sha256 = ''1j0drddahdjab40dd9v9qy92xbvzwgbk6y3hv990sdp9f8ac1q45'';
  };

  overrides = x: {
  };
}
