/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-garbage";
  version = "20200925-git";

  parasites = [ "trivial-garbage/tests" ];

  description = "Portable finalizers, weak hash-tables and weak pointers.";

  deps = [ args."rt" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-garbage/2020-09-25/trivial-garbage-20200925-git.tgz";
    sha256 = "00iw2iw6qzji9b2gwy798l54jdk185sxh1k7m2qd9srs8s730k83";
  };

  packageName = "trivial-garbage";

  asdFilesToKeep = ["trivial-garbage.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-garbage DESCRIPTION
    Portable finalizers, weak hash-tables and weak pointers. SHA256
    00iw2iw6qzji9b2gwy798l54jdk185sxh1k7m2qd9srs8s730k83 URL
    http://beta.quicklisp.org/archive/trivial-garbage/2020-09-25/trivial-garbage-20200925-git.tgz
    MD5 9d748d1d549f419ce474f35906707420 NAME trivial-garbage FILENAME
    trivial-garbage DEPS ((NAME rt FILENAME rt)) DEPENDENCIES (rt) VERSION
    20200925-git SIBLINGS NIL PARASITES (trivial-garbage/tests)) */
