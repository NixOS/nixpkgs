args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-gray-streams'';
  version = ''20181018-git'';

  description = ''Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-gray-streams/2018-10-18/trivial-gray-streams-20181018-git.tgz'';
    sha256 = ''0a1dmf7m9zbv3p6f5mzb413cy4fz9ahaykqp3ik1a98ivy0i74iv'';
  };

  packageName = "trivial-gray-streams";

  asdFilesToKeep = ["trivial-gray-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-gray-streams DESCRIPTION
    Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).
    SHA256 0a1dmf7m9zbv3p6f5mzb413cy4fz9ahaykqp3ik1a98ivy0i74iv URL
    http://beta.quicklisp.org/archive/trivial-gray-streams/2018-10-18/trivial-gray-streams-20181018-git.tgz
    MD5 0a9f564079dc41ce10d7869d82cc0952 NAME trivial-gray-streams FILENAME
    trivial-gray-streams DEPS NIL DEPENDENCIES NIL VERSION 20181018-git
    SIBLINGS (trivial-gray-streams-test) PARASITES NIL) */
