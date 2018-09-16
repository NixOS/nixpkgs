args @ { fetchurl, ... }:
rec {
  baseName = ''usocket'';
  version = ''0.7.1'';

  description = ''Universal socket library for Common Lisp'';

  deps = [ args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/usocket/2018-08-31/usocket-0.7.1.tgz'';
    sha256 = ''18w2f835lgiznv6rm1v7yq94dg5qjcmbj91kpvfjw81pk4i7i7lw'';
  };

  packageName = "usocket";

  asdFilesToKeep = ["usocket.asd"];
  overrides = x: x;
}
/* (SYSTEM usocket DESCRIPTION Universal socket library for Common Lisp SHA256
    18w2f835lgiznv6rm1v7yq94dg5qjcmbj91kpvfjw81pk4i7i7lw URL
    http://beta.quicklisp.org/archive/usocket/2018-08-31/usocket-0.7.1.tgz MD5
    fb48ff59f0d71bfc9c2939aacdb123a0 NAME usocket FILENAME usocket DEPS
    ((NAME split-sequence FILENAME split-sequence)) DEPENDENCIES
    (split-sequence) VERSION 0.7.1 SIBLINGS (usocket-server usocket-test)
    PARASITES NIL) */
