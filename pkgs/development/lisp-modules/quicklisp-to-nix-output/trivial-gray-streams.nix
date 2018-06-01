args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-gray-streams'';
  version = ''20180328-git'';

  description = ''Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-gray-streams/2018-03-28/trivial-gray-streams-20180328-git.tgz'';
    sha256 = ''01z5mp71005vgpvazhs3gqgqr2ym8mm4n5pw2y7bfjiygcl8b06f'';
  };

  packageName = "trivial-gray-streams";

  asdFilesToKeep = ["trivial-gray-streams.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-gray-streams DESCRIPTION
    Compatibility layer for Gray Streams (see http://www.cliki.net/Gray%20streams).
    SHA256 01z5mp71005vgpvazhs3gqgqr2ym8mm4n5pw2y7bfjiygcl8b06f URL
    http://beta.quicklisp.org/archive/trivial-gray-streams/2018-03-28/trivial-gray-streams-20180328-git.tgz
    MD5 9f831cbb7a4efe93eaa8fa2acee4b01b NAME trivial-gray-streams FILENAME
    trivial-gray-streams DEPS NIL DEPENDENCIES NIL VERSION 20180328-git
    SIBLINGS (trivial-gray-streams-test) PARASITES NIL) */
