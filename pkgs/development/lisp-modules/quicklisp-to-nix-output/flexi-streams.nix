args @ { fetchurl, ... }:
rec {
  baseName = ''flexi-streams'';
  version = ''20180328-git'';

  parasites = [ "flexi-streams-test" ];

  description = ''Flexible bivalent streams for Common Lisp'';

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/flexi-streams/2018-03-28/flexi-streams-20180328-git.tgz'';
    sha256 = ''0hdmzihii3wv6769dfkkw15avpgifizdd7lxdlgjk7h0h8v7yw11'';
  };

  packageName = "flexi-streams";

  asdFilesToKeep = ["flexi-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM flexi-streams DESCRIPTION Flexible bivalent streams for Common Lisp
    SHA256 0hdmzihii3wv6769dfkkw15avpgifizdd7lxdlgjk7h0h8v7yw11 URL
    http://beta.quicklisp.org/archive/flexi-streams/2018-03-28/flexi-streams-20180328-git.tgz
    MD5 af40ae10a0aab65eccfe161a32e1033b NAME flexi-streams FILENAME
    flexi-streams DEPS
    ((NAME trivial-gray-streams FILENAME trivial-gray-streams)) DEPENDENCIES
    (trivial-gray-streams) VERSION 20180328-git SIBLINGS NIL PARASITES
    (flexi-streams-test)) */
