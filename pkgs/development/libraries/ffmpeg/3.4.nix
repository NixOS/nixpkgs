{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.4";
  sha256 = "0pn8g3ab937ahslqd41crk0g4j4fh7kwimsrlfc0rl0pc3z132ax";
  darwinFrameworks = [ Cocoa CoreMedia ];

  patches = [
    (fetchpatch{
      name = "CVE-2017-16840.patch";
      url = "http://git.videolan.org/?p=ffmpeg.git;a=patch;h=a94cb36ab2ad99d3a1331c9f91831ef593d94f74";
      sha256 = "1rjr9lc71cyy43wsa2zxb9ygya292h9jflvr5wk61nf0vp97gjg3";
    })
  ];

})
