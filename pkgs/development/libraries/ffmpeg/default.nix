{
  callPackage,
  darwin,
  cudaPackages,
}:

let
  mkFFmpeg =
    initArgs: ffmpegVariant:
    callPackage ./generic.nix (
      {
        inherit (darwin.apple_sdk.frameworks)
          Accelerate
          AppKit
          AudioToolbox
          AVFoundation
          CoreImage
          VideoToolbox
          ;
        inherit (darwin) xcode;
        inherit (cudaPackages) cuda_cudart cuda_nvcc libnpp;
      }
      // (initArgs // { inherit ffmpegVariant; })
    );

  v4 = {
    version = "4.4.5";
    hash = "sha256-GrKNGYI8kO47Yoi82dMV30ymuXSjxo4gH+yB8jIUa2A=";
  };

  v6 = {
    version = "6.1.2";
    hash = "sha256-h/N56iKkAR5kH+PRQceWZvHe3k+70KWMDEP5iVq/YFQ=";
  };

  v7 = {
    version = "7.0.2";
    hash = "sha256-6bcTxMt0rH/Nso3X7zhrFNkkmWYtxsbUqVQKh25R1Fs=";
  };
in

rec {
  # We keep FFmpeg 4 around for now mainly for a couple of binary
  # packages (Spotify and REAPER). Please don’t add new source packages
  # that depend on this version.
  ffmpeg_4 = mkFFmpeg v4 "small";
  ffmpeg_4-headless = mkFFmpeg v4 "headless";
  ffmpeg_4-full = mkFFmpeg v4 "full";

  ffmpeg_6 = mkFFmpeg v6 "small";
  ffmpeg_6-headless = mkFFmpeg v6 "headless";
  ffmpeg_6-full = mkFFmpeg v6 "full";

  ffmpeg_7 = mkFFmpeg v7 "small";
  ffmpeg_7-headless = mkFFmpeg v7 "headless";
  ffmpeg_7-full = mkFFmpeg v7 "full";

  # Please make sure this is updated to new major versions once they
  # build and work on all the major platforms. If absolutely necessary
  # due to severe breaking changes, the bump can wait a little bit to
  # give the most proactive users time to migrate, but don’t hold off
  # for too long.
  #
  # Packages which depend on FFmpeg should generally use these
  # unversioned aliases to allow for quicker migration to new releases,
  # but can pin one of the versioned variants if they do not work with
  # the current default version.
  ffmpeg = ffmpeg_7;
  ffmpeg-headless = ffmpeg_7-headless;
  ffmpeg-full = ffmpeg_7-full;
}
