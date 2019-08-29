args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-garbage'';
  version = ''20190521-git'';

  parasites = [ "trivial-garbage/tests" ];

  description = ''Portable finalizers, weak hash-tables and weak pointers.'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-garbage/2019-05-21/trivial-garbage-20190521-git.tgz'';
    sha256 = ''0yhb7rkrbcfgghwvbw13nvmr86v19ka6qb53j8n89c7r270d8fdl'';
  };

  packageName = "trivial-garbage";

  asdFilesToKeep = ["trivial-garbage.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-garbage DESCRIPTION
    Portable finalizers, weak hash-tables and weak pointers. SHA256
    0yhb7rkrbcfgghwvbw13nvmr86v19ka6qb53j8n89c7r270d8fdl URL
    http://beta.quicklisp.org/archive/trivial-garbage/2019-05-21/trivial-garbage-20190521-git.tgz
    MD5 38fb70797069d4402c6b0fe91f4ca5a8 NAME trivial-garbage FILENAME
    trivial-garbage DEPS ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION
    20190521-git SIBLINGS NIL PARASITES (trivial-garbage/tests)) */
