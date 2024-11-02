{
  ffmpeg_7-full,
  fetchFromGitHub,
  fetchpatch2,
  lib,
}:

let
  version = "7.0.2-5";
in

(ffmpeg_7-full.override {
  inherit version; # Important! This sets the ABI.
  source = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
    hash = "sha256-cqyXQNx65eLEumOoSCucNpAqShMhiPqzsKc/GjKKQOA=";
  };
}).overrideAttrs
  (old: {
    pname = "jellyfin-ffmpeg";

    configureFlags = old.configureFlags ++ [
      "--extra-version=Jellyfin"
      "--disable-ptx-compression" # https://github.com/jellyfin/jellyfin/issues/7944#issuecomment-1156880067
    ];

    patches = [
      # xeve got an update that broke builds of ffmpeg 7.0.2, is fixed upstream from 7.1 onwards.
      (fetchpatch2 {
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/3e6c7948626f19c46c1a630c788ea6bbd9e7fbcb";
        hash = "sha256-HmijTDNqKaNpIMe3re4rIMKEo2udd7VFZdryV/+xiYM=";
        excludes = [ "libavcodec/version.h" ];
      })
    ];

    postPatch = ''
      for file in $(cat debian/patches/series); do
        patch -p1 < debian/patches/$file
      done

      ${old.postPatch or ""}
    '';

    meta = {
      inherit (old.meta) license mainProgram;
      changelog = "https://github.com/jellyfin/jellyfin-ffmpeg/releases/tag/v${version}";
      description = "${old.meta.description} (Jellyfin fork)";
      homepage = "https://github.com/jellyfin/jellyfin-ffmpeg";
      maintainers = with lib.maintainers; [ justinas ];
      pkgConfigModules = [ "libavutil" ];
    };
  })
