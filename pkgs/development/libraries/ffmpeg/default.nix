{ callPackage, darwin }:

let
  mkFFmpeg =
    initArgs: ffmpegVariant:
    callPackage ./generic.nix (
      {
        inherit (darwin.apple_sdk.frameworks)
          Cocoa
          CoreServices
          CoreAudio
          CoreMedia
          AVFoundation
          MediaToolbox
          VideoDecodeAcceleration
          VideoToolbox
          ;
      }
      // (initArgs // { inherit ffmpegVariant; })
    );

  v4 = {
    version = "4.4.4";
    hash = "sha256-Q8bkuF/1uJfqttJJoObnnLX3BEduv+qxsvOrVhMvRjA=";
  };

  v5 = {
    version = "5.1.4";
    hash = "sha256-2jUL1/xGUf7aMooST2DW41KE7bC+BtgChXmj0sAJZ90=";
  };

  v6 = {
    version = "6.1.1";
    hash = "sha256-Q0c95hbCVUHQWPoh5uC8uzMylmB4BnWg+VhXEgSouzo=";
  };
in

rec {
  ffmpeg_4 = mkFFmpeg v4 "small";
  ffmpeg_4-headless = mkFFmpeg v4 "headless";
  ffmpeg_4-full = mkFFmpeg v4 "full";

  ffmpeg_5 = mkFFmpeg v5 "small";
  ffmpeg_5-headless = mkFFmpeg v5 "headless";
  ffmpeg_5-full = mkFFmpeg v5 "full";

  ffmpeg_6 = mkFFmpeg v6 "small";
  ffmpeg_6-headless = mkFFmpeg v6 "headless";
  ffmpeg_6-full = mkFFmpeg v6 "full";

  # Please make sure this is updated to the latest version on the next major
  # update to ffmpeg
  # Packages which use ffmpeg as a library, should pin to the relevant major
  # version number which the upstream support.
  ffmpeg = ffmpeg_6;
  ffmpeg-headless = ffmpeg_6-headless;
  ffmpeg-full = ffmpeg_6-full;
}
