/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "bordeaux-threads";
  version = "v0.8.8";

  parasites = [ "bordeaux-threads/test" ];

  description = "Bordeaux Threads makes writing portable multi-threaded apps simple.";

  deps = [ args."alexandria" args."fiveam" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/bordeaux-threads/2020-06-10/bordeaux-threads-v0.8.8.tgz";
    sha256 = "1ppb7lvr796k1j4hi0jnp717v9zxy6vq4f5cyzgn7svg1ic6l0pp";
  };

  packageName = "bordeaux-threads";

  asdFilesToKeep = ["bordeaux-threads.asd"];
  overrides = x: x;
}
/* (SYSTEM bordeaux-threads DESCRIPTION
    Bordeaux Threads makes writing portable multi-threaded apps simple. SHA256
    1ppb7lvr796k1j4hi0jnp717v9zxy6vq4f5cyzgn7svg1ic6l0pp URL
    http://beta.quicklisp.org/archive/bordeaux-threads/2020-06-10/bordeaux-threads-v0.8.8.tgz
    MD5 1922316721bcaa10142ed07c31b178e5 NAME bordeaux-threads FILENAME
    bordeaux-threads DEPS
    ((NAME alexandria FILENAME alexandria) (NAME fiveam FILENAME fiveam))
    DEPENDENCIES (alexandria fiveam) VERSION v0.8.8 SIBLINGS NIL PARASITES
    (bordeaux-threads/test)) */
