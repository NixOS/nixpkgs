{ callPackage, darwin }:

let
  mkFFmpeg = args: callPackage (import ./generic.nix args) {
    inherit (darwin.apple_sdk.frameworks)
      Cocoa CoreServices CoreAudio CoreMedia AVFoundation MediaToolbox
      VideoDecodeAcceleration VideoToolbox;
  };

  mkFFmpeg_4 = variant: mkFFmpeg {
    version = "4.4.4";
    hash = "sha256-Q8bkuF/1uJfqttJJoObnnLX3BEduv+qxsvOrVhMvRjA=";
    inherit variant;
  };

  mkFFmpeg_5 = variant: mkFFmpeg {
    version = "5.1.3";
    hash = "sha256-twfJvANLQGO7TiyHPMPqApfHLFUlOGZTTIIGEnjyvuE=";
    inherit variant;
  };

  mkFFmpeg_6 = variant: mkFFmpeg {
    version = "6.1";
    hash = "sha256-NzhD2D16bCVCyCXo0TRwZYp3Ta5eFSfoQPa+iRkeNZg=";
    inherit variant;
  };
in

rec {
  ffmpeg_4 = mkFFmpeg_4 "small";
  ffmpeg_4-headless = mkFFmpeg_4 "headless";
  ffmpeg_4-full = mkFFmpeg_4 "full";

  ffmpeg_5 = mkFFmpeg_5 "small";
  ffmpeg_5-headless = mkFFmpeg_5 "headless";
  ffmpeg_5-full = mkFFmpeg_5 "full";

  ffmpeg_6 = mkFFmpeg_6 "small";
  ffmpeg_6-headless = mkFFmpeg_6 "headless";
  ffmpeg_6-full = mkFFmpeg_6 "full";

  # Please make sure this is updated to the latest version on the next major
  # update to ffmpeg
  # Packages which use ffmpeg as a library, should pin to the relevant major
  # version number which the upstream support.
  ffmpeg = ffmpeg_6;
  ffmpeg-headless = ffmpeg_6-headless;
  ffmpeg-full = ffmpeg_6-full;
}
