{ lib
, stdenv
, callPackage
, fetchurl
}:

{
  buildGraalvmProduct = callPackage ./buildGraalvmProduct.nix;

  graalvm-ce = callPackage ./graalvm-ce { };

  graalvm-ce-musl = callPackage ./graalvm-ce { useMusl = true; };

  graaljs = callPackage ./graaljs { };

  graalnodejs = callPackage ./graalnodejs { };

  graalpy = callPackage ./graalpy { };

  truffleruby = callPackage ./truffleruby { };
}
