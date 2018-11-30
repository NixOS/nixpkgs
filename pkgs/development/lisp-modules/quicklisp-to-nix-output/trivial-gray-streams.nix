args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-gray-streams'';
  version = ''20180831-git'';

  description = ''Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-gray-streams/2018-08-31/trivial-gray-streams-20180831-git.tgz'';
    sha256 = ''0mh9w8inqxb6lpq787grnf72qlcrjd0a7qs6psjyfs6iazs14170'';
  };

  packageName = "trivial-gray-streams";

  asdFilesToKeep = ["trivial-gray-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-gray-streams DESCRIPTION
    Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).
    SHA256 0mh9w8inqxb6lpq787grnf72qlcrjd0a7qs6psjyfs6iazs14170 URL
    http://beta.quicklisp.org/archive/trivial-gray-streams/2018-08-31/trivial-gray-streams-20180831-git.tgz
    MD5 070733919aa016a508b2ecb443e37c80 NAME trivial-gray-streams FILENAME
    trivial-gray-streams DEPS NIL DEPENDENCIES NIL VERSION 20180831-git
    SIBLINGS (trivial-gray-streams-test) PARASITES NIL) */
