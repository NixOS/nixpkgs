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
    version = "4.4.8";
    hash = "sha256-byCiCiuwrikID6hCe0CD2KyPVUYuGmas5Zs0fd6dJRQ=";
  };

  v6 = {
    version = "6.1.6";
    hash = "sha256-7Mu0D9AVR+rVfqtZMmNV9EUNpUyMr09p/PuET0muS0U=";
  };

  v7 = {
    version = "7.1.5";
    hash = "sha256-DjmW5LeI9OJmPeIh61znAns4+kolxwKguEvKawgxy8I=";
  };
  v8 = {
    version = "8.1.2";
    hash = "sha256-wJ3c8VVo/tK84K7bKYs/UWcln4mSO+tf/w5NLNjKhiI=";
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

  ffmpeg_8 = mkFFmpeg v8 "small";
  ffmpeg_8-headless = mkFFmpeg v8 "headless";
  ffmpeg_8-full = mkFFmpeg v8 "full";

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
  ffmpeg = ffmpeg_8;
  ffmpeg-headless = ffmpeg_8-headless;
  ffmpeg-full = ffmpeg_8-full;
}
