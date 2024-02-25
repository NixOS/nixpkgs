import ./generic.nix {
  version = "6.1";
  hash = "sha256-NzhD2D16bCVCyCXo0TRwZYp3Ta5eFSfoQPa+iRkeNZg=";
  extraPatches = [
    {
      name = "avcodec-decode-validate-hw-frames-ctx.patch";
      url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/e9c93009fc34ca9dfcf0c6f2ed90ef1df298abf7";
      hash = "sha256-aE9WN7a2INbss7oRys+AC9d9+yBzlJdeBRcwSDpG0Qw=";
    }
  ];
}
