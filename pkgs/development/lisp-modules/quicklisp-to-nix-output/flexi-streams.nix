args @ { fetchurl, ... }:
rec {
  baseName = ''flexi-streams'';
  version = ''1.0.15'';

  description = ''Flexible bivalent streams for Common Lisp'';

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/flexi-streams/2015-07-09/flexi-streams-1.0.15.tgz'';
    sha256 = ''0zkx335winqs7xigbmxhhkhcsfa9hjhf1q6r4q710y29fbhpc37p'';
  };
}
