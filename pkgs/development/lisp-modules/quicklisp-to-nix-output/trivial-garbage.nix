args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-garbage'';
  version = ''20150113-git'';

  description = ''Portable finalizers, weak hash-tables and weak pointers.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-garbage/2015-01-13/trivial-garbage-20150113-git.tgz'';
    sha256 = ''1yy1jyx7wz5rr7lr0jyyfxgzfddmrxrmkp46a21pcdc4jlss1h08'';
  };
}
