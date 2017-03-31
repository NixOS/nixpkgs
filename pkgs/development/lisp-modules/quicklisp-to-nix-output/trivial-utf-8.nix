args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-utf-8'';
  version = ''20111001-darcs'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-utf-8/2011-10-01/trivial-utf-8-20111001-darcs.tgz'';
    sha256 = ''1lmg185s6w3rzsz3xa41k5w9xw32bi288ifhrxincy8iv92w65wb'';
  };

  overrides = x: {
  };
}
