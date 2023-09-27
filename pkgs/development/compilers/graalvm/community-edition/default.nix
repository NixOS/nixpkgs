{ lib
, stdenv
, callPackage
, fetchurl
}:

{
  buildGraalvm = callPackage ./buildGraalvm.nix;

  buildGraalvmProduct = callPackage ./buildGraalvmProduct.nix;

  graalvm-ce = callPackage ./graalvm-ce { };

  graaljs = callPackage ./graaljs { };

  graalnodejs = callPackage ./graalnodejs { };

  graalpy = callPackage ./graalpy { };

  truffleruby = callPackage ./truffleruby { };
}
