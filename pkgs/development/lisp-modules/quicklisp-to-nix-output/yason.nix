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

  packageName = "yason";

  asdFilesToKeep = ["yason.asd"];
  overrides = x: x;
}
/* (SYSTEM yason DESCRIPTION JSON parser/encoder SHA256
    00gfn14bvnw0in03y5m2ssgvhy3ppf5a3s0rf7mf4rq00c5ifchk URL
    http://beta.quicklisp.org/archive/yason/2016-02-08/yason-v0.7.6.tgz MD5
    79de5d242c5e9ce49dfda153d5f442ec NAME yason FILENAME yason DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria trivial-gray-streams) VERSION v0.7.6 SIBLINGS NIL
    PARASITES NIL) */
