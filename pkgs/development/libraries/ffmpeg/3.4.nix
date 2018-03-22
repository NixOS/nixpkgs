{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.4.2";
  sha256 = "0nkq4451masmzlx3p4vprqwc0sl2iwqxbzjrngmvj29q4azp00zb";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
