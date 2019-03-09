args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-garbage'';
  version = ''20181018-git'';

  parasites = [ "trivial-garbage-tests" ];

  description = ''Portable finalizers, weak hash-tables and weak pointers.'';

  deps = [ args."rt" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-garbage/2018-10-18/trivial-garbage-20181018-git.tgz'';
    sha256 = ''0hiflg8iak99bbgv0lqj6zwqyklx85ixp7yp4r8xzzm61ya613pl'';
  };

  packageName = "trivial-garbage";

  asdFilesToKeep = ["trivial-garbage.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-garbage DESCRIPTION
    Portable finalizers, weak hash-tables and weak pointers. SHA256
    0hiflg8iak99bbgv0lqj6zwqyklx85ixp7yp4r8xzzm61ya613pl URL
    http://beta.quicklisp.org/archive/trivial-garbage/2018-10-18/trivial-garbage-20181018-git.tgz
    MD5 4d1d1ab0518b375da21b9a6eeaa498e3 NAME trivial-garbage FILENAME
    trivial-garbage DEPS ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION
    20181018-git SIBLINGS NIL PARASITES (trivial-garbage-tests)) */
