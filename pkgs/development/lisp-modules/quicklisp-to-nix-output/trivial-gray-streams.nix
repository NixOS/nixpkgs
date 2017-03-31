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

  overrides = x: {
  };
}
