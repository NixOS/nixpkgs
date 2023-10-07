{ lib
, stdenv
, callPackage
, fetchurl
}:

{

  buildGraalvm = callPackage ./buildGraalvm.nix;

}
