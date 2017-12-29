args @ { fetchurl, ... }:
rec {
  baseName = ''nibbles'';
  version = ''20170403-git'';

  parasites = [ "nibbles-tests" ];

  description = ''A library for accessing octet-addressed blocks of data in big- and little-endian orders'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/nibbles/2017-04-03/nibbles-20170403-git.tgz'';
    sha256 = ''0bg7jwhqhm3qmpzk21gjv50sl0grdn68d770cqfs7in62ny35lk4'';
  };

  packageName = "nibbles";

  asdFilesToKeep = ["nibbles.asd"];
  overrides = x: x;
}
/* (SYSTEM nibbles DESCRIPTION
    A library for accessing octet-addressed blocks of data in big- and little-endian orders
    SHA256 0bg7jwhqhm3qmpzk21gjv50sl0grdn68d770cqfs7in62ny35lk4 URL
    http://beta.quicklisp.org/archive/nibbles/2017-04-03/nibbles-20170403-git.tgz
    MD5 5683a0a5510860a036b2a272036cda87 NAME nibbles FILENAME nibbles DEPS NIL
    DEPENDENCIES NIL VERSION 20170403-git SIBLINGS NIL PARASITES
    (nibbles-tests)) */
