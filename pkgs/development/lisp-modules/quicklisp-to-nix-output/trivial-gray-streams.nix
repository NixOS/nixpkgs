args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-gray-streams'';
  version = ''20200925-git'';

  description = ''Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-gray-streams/2020-09-25/trivial-gray-streams-20200925-git.tgz'';
    sha256 = ''1mg31fwjixd04lfqbpzjan3cny1i478xm1a9l3p0i9m4dv4g2k2b'';
  };

  packageName = "trivial-gray-streams";

  asdFilesToKeep = ["trivial-gray-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-gray-streams DESCRIPTION
    Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).
    SHA256 1mg31fwjixd04lfqbpzjan3cny1i478xm1a9l3p0i9m4dv4g2k2b URL
    http://beta.quicklisp.org/archive/trivial-gray-streams/2020-09-25/trivial-gray-streams-20200925-git.tgz
    MD5 123581593fc46fdbf1d631cf8f07e0dd NAME trivial-gray-streams FILENAME
    trivial-gray-streams DEPS NIL DEPENDENCIES NIL VERSION 20200925-git
    SIBLINGS (trivial-gray-streams-test) PARASITES NIL) */
