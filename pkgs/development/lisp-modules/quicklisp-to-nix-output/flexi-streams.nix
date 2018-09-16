args @ { fetchurl, ... }:
rec {
  baseName = ''flexi-streams'';
  version = ''20180711-git'';

  parasites = [ "flexi-streams-test" ];

  description = ''Flexible bivalent streams for Common Lisp'';

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/flexi-streams/2018-07-11/flexi-streams-20180711-git.tgz'';
    sha256 = ''1g7a5fbl84zx3139kvvgwq6d8bnbpbvq9mr5yj4jzfa6pjfjwgz2'';
  };

  packageName = "flexi-streams";

  asdFilesToKeep = ["flexi-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM flexi-streams DESCRIPTION Flexible bivalent streams for Common Lisp
    SHA256 1g7a5fbl84zx3139kvvgwq6d8bnbpbvq9mr5yj4jzfa6pjfjwgz2 URL
    http://beta.quicklisp.org/archive/flexi-streams/2018-07-11/flexi-streams-20180711-git.tgz
    MD5 1e5bc255540dcbd71f9cba56573cfb4c NAME flexi-streams FILENAME
    flexi-streams DEPS
    ((NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES
    (trivial-gray-streams) VERSION 20180711-git SIBLINGS NIL PARASITES
    (flexi-streams-test)) */
