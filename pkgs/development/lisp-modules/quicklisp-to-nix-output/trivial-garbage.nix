args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-garbage'';
  version = ''20150113-git'';

  parasites = [ "trivial-garbage-tests" ];

  description = ''Portable finalizers, weak hash-tables and weak pointers.'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-garbage/2015-01-13/trivial-garbage-20150113-git.tgz'';
    sha256 = ''1yy1jyx7wz5rr7lr0jyyfxgzfddmrxrmkp46a21pcdc4jlss1h08'';
  };

  packageName = "trivial-garbage";

  asdFilesToKeep = ["trivial-garbage.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-garbage DESCRIPTION
    Portable finalizers, weak hash-tables and weak pointers. SHA256
    1yy1jyx7wz5rr7lr0jyyfxgzfddmrxrmkp46a21pcdc4jlss1h08 URL
    http://beta.quicklisp.org/archive/trivial-garbage/2015-01-13/trivial-garbage-20150113-git.tgz
    MD5 59153568703eed631e53092ab67f935e NAME trivial-garbage FILENAME
    trivial-garbage DEPS ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION
    20150113-git SIBLINGS NIL PARASITES (trivial-garbage-tests)) */
