args @ { fetchurl, ... }:
rec {
  baseName = ''flexi-streams'';
  version = ''1.0.15'';

  parasites = [ "flexi-streams-test" ];

  description = ''Flexible bivalent streams for Common Lisp'';

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/flexi-streams/2015-07-09/flexi-streams-1.0.15.tgz'';
    sha256 = ''0zkx335winqs7xigbmxhhkhcsfa9hjhf1q6r4q710y29fbhpc37p'';
  };

  packageName = "flexi-streams";

  asdFilesToKeep = ["flexi-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM flexi-streams DESCRIPTION Flexible bivalent streams for Common Lisp
    SHA256 0zkx335winqs7xigbmxhhkhcsfa9hjhf1q6r4q710y29fbhpc37p URL
    http://beta.quicklisp.org/archive/flexi-streams/2015-07-09/flexi-streams-1.0.15.tgz
    MD5 02dbb5a0c5f982e0c7a88aad9a25004e NAME flexi-streams FILENAME
    flexi-streams DEPS
    ((NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES
    (trivial-gray-streams) VERSION 1.0.15 SIBLINGS NIL PARASITES
    (flexi-streams-test)) */
