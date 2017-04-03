{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.7";
  branch = "3.1";
  sha256 = "0ldf484r3waslv0sjx3vcwlkfgh28bd1wqcj26snfhav7zkf10kl";
  darwinFrameworks = [ Cocoa CoreMedia ];
  patches = stdenv.lib.optional stdenv.isDarwin ./sdk_detection.patch;
})
