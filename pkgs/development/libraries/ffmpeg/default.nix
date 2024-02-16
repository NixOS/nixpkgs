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
    extraPatches = [
      {
        name = "libsvtav1-1.5.0-compat-compressed_ten_bit_format.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/031f1561cd286596cdb374da32f8aa816ce3b135";
        hash = "sha256-mSnmAkoNikDpxcN+A/hpB7mUbbtcMvm4tG6gZFuroe8=";
      }
      # The upstream patch isn’t for ffmpeg 4, but it will apply with a few tweaks.
      # Fixes a crash when built with clang 16 due to UB in ff_seek_frame_binary.
      {
        name = "utils-fix_crash_in_ff_seek_frame_binary.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/ab792634197e364ca1bb194f9abe36836e42f12d";
        hash = "sha256-UxZ4VneZpw+Q/UwkEUDNdb2nOx1QnMrZ40UagspNTxI=";
        postFetch = ''
        substituteInPlace "$out" \
          --replace libavformat/seek.c libavformat/utils.c \
          --replace 'const AVInputFormat *const ' 'const AVInputFormat *'
      '';
      }
    ];

    inherit variant;
  };

  mkFFmpeg_5 = variant: mkFFmpeg {
    version = "5.1.3";
    hash = "sha256-twfJvANLQGO7TiyHPMPqApfHLFUlOGZTTIIGEnjyvuE=";
    extraPatches = [
      {
        name = "libsvtav1-1.5.0-compat-compressed_ten_bit_format.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/031f1561cd286596cdb374da32f8aa816ce3b135";
        hash = "sha256-mSnmAkoNikDpxcN+A/hpB7mUbbtcMvm4tG6gZFuroe8=";
      }
      {
        name = "libsvtav1-1.5.0-compat-vbv_bufsize.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/1c6fd7d756afe0f8b7df14dbf7a95df275f8f5ee";
        hash = "sha256-v9Viyo12QfZpbcVqd1aHgLl/DgSkdE9F1kr6afTGPik=";
      }
      {
        name = "libsvtav1-1.5.0-compat-maximum_buffer_size_ms-conditional.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/96748ac54f998ba6fe22802799c16b4eba8d4ccc";
        hash = "sha256-Z5HSe7YpryYGHD3BYXejAhqR4EPnmfTGyccxNvU3AaU=";
      }
    ];

    inherit variant;
  };

  mkFFmpeg_6 = variant: mkFFmpeg {
    version = "6.1";
    hash = "sha256-NzhD2D16bCVCyCXo0TRwZYp3Ta5eFSfoQPa+iRkeNZg=";

    extraPatches = [
      {
        name = "avcodec-decode-validate-hw-frames-ctx.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/e9c93009fc34ca9dfcf0c6f2ed90ef1df298abf7";
        hash = "sha256-aE9WN7a2INbss7oRys+AC9d9+yBzlJdeBRcwSDpG0Qw=";
      }
    ];

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
