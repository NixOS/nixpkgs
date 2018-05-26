args @ { fetchurl, ... }:
rec {
  baseName = ''nibbles'';
  version = ''20171130-git'';

  parasites = [ "nibbles/tests" ];

  description = ''A library for accessing octet-addressed blocks of data in big- and little-endian orders'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/nibbles/2017-11-30/nibbles-20171130-git.tgz'';
    sha256 = ''05ykyniak1m0whr7pnbhg53yblr5mny0crmh72bmgnvpmkm345zn'';
  };

  packageName = "nibbles";

  asdFilesToKeep = ["nibbles.asd"];
  overrides = x: x;
}
/* (SYSTEM nibbles DESCRIPTION
    A library for accessing octet-addressed blocks of data in big- and little-endian orders
    SHA256 05ykyniak1m0whr7pnbhg53yblr5mny0crmh72bmgnvpmkm345zn URL
    http://beta.quicklisp.org/archive/nibbles/2017-11-30/nibbles-20171130-git.tgz
    MD5 edce3702da9979fca3e40a4594fe36e6 NAME nibbles FILENAME nibbles DEPS NIL
    DEPENDENCIES NIL VERSION 20171130-git SIBLINGS NIL PARASITES
    (nibbles/tests)) */
