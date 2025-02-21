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
        inherit (darwin) xcode;
        inherit (cudaPackages) cuda_cudart cuda_nvcc libnpp;
      }
      // (initArgs // { inherit ffmpegVariant; })
    );

  v4 = {
    version = "4.4"; # release/4.4
    rev = "146951502168f2671a8511ad4c6410a87b7f8478";
    hash = "sha256-WxunplCBLAlLPpavbpZLCPeW9hjfCWgXmFP578q31VI=";
  };

  v6 = {
    version = "6.1"; # release/6.1
    rev = "138f52a3a1c49843d8bf2b693b6f6781356020f9";
    hash = "sha256-oPVtgQJgZaIKpUKQz4/FBZ0U1AwpkS84GUWSkdHEonM=";
  };

  v7 = {
    version = "7.1"; # release/7.1
    rev = "8cabfd922a726a964eeae8b5276583f470df39c3";
    hash = "sha256-qkfth1Hi97cEHmnBpVc2SJxF2Uq5tQqa6ulnT0YA5lA=";
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
