args @ { fetchurl, ... }:
rec {
  baseName = ''yason'';
  version = ''v0.7.6'';

  description = ''JSON parser/encoder'';

  deps = [ args."alexandria" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/yason/2016-02-08/yason-v0.7.6.tgz'';
    sha256 = ''00gfn14bvnw0in03y5m2ssgvhy3ppf5a3s0rf7mf4rq00c5ifchk'';
  };

  overrides = x: {
  };
}
