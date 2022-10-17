{ callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, stdenv, lib
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.4.2";
  branch = version;
  sha256 = "sha256-+YpIJSDEdQdSGpB5FNqp77wThOBZG1r8PaGKqJfeKUg=";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
  patches = [
    #  sdl2 recently changed their versioning
    (fetchpatch {
      url = "https://git.videolan.org/?p=ffmpeg.git;a=patch;h=e5163b1d34381a3319214a902ef1df923dd2eeba";
      hash = "sha256-nLhP2+34cj5EgpnUrePZp60nYAxmbhZAEDfay4pBVk0=";
    })
  ];
} // args)
