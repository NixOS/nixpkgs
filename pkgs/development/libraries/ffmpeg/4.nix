{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, stdenv, lib
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.4";
  branch = "4.4";
  sha256 = "03kxc29y8190k4y8s8qdpsghlbpmchv1m8iqygq2qn0vfm4ka2a2";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];

  /* Work around https://trac.ffmpeg.org/ticket/9242 */
  patches = lib.optional stdenv.isDarwin
    ./v2-0001-avcodec-videotoolboxenc-define-TARGET_CPU_ARM64-t.patch;
} // args)
