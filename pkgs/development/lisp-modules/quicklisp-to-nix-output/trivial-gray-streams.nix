args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-gray-streams'';
  version = ''20140826-git'';

  description = ''Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-gray-streams/2014-08-26/trivial-gray-streams-20140826-git.tgz'';
    sha256 = ''1nhbp0qizvqvy2mfl3i99hlwiy27h3gq0jglwzsj2fmnwqvpfx92'';
  };

  packageName = "trivial-gray-streams";

  asdFilesToKeep = ["trivial-gray-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-gray-streams DESCRIPTION
    Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).
    SHA256 1nhbp0qizvqvy2mfl3i99hlwiy27h3gq0jglwzsj2fmnwqvpfx92 URL
    http://beta.quicklisp.org/archive/trivial-gray-streams/2014-08-26/trivial-gray-streams-20140826-git.tgz
    MD5 1ca280830c8c438ca2ccfadb3763ae83 NAME trivial-gray-streams FILENAME
    trivial-gray-streams DEPS NIL DEPENDENCIES NIL VERSION 20140826-git
    SIBLINGS (trivial-gray-streams-test) PARASITES NIL) */
