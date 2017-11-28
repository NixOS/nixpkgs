{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.3.5";
  sha256 = "02h6y5sadqmci2ssalaxg65wa69ldscj05311zym8zijibzlqhqv";
  darwinFrameworks = [ Cocoa CoreMedia ];

  patches = [
    (fetchpatch{
      name = "CVE-2017-16840.patch";
      url = "http://git.videolan.org/?p=ffmpeg.git;a=patch;h=a94cb36ab2ad99d3a1331c9f91831ef593d94f74";
      sha256 = "1rjr9lc71cyy43wsa2zxb9ygya292h9jflvr5wk61nf0vp97gjg3";
    })
  ];

})
