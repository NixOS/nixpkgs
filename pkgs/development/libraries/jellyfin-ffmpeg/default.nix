{ ffmpeg_5, ffmpeg-full, fetchFromGitHub, lib }:

(ffmpeg-full.override { ffmpeg = ffmpeg_5; }).overrideAttrs (old: rec {
  pname = "jellyfin-ffmpeg";
  version = "5.0.1-5";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-ffmpeg";
    rev = "v${version}";
    sha256 = "sha256-rFzBAniw2vQGFn2GDlz6NiB/Ow2EZlE3Lu+ceYTStkM=";
  };

  postPatch = ''
    for file in $(cat debian/patches/series); do
      patch -p1 < debian/patches/$file
    done

    ${old.postPatch or ""}
  '';

  doCheck = false; # https://github.com/jellyfin/jellyfin-ffmpeg/issues/79

  meta = with lib; {
    description = "${old.meta.description} (Jellyfin fork)";
    homepage = "https://github.com/jellyfin/jellyfin-ffmpeg";
    license = licenses.gpl3;
    maintainers = with maintainers; [ justinas ];
  };
})
